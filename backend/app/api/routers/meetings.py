from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.di.auth import get_current_user
from app.core.di.meetings import get_meeting_service
from app.infrastructure.db.models.user import User
from app.modules.meetings.schemas import (
    MeetingCreateRequest,
    MeetingListResponse,
    MeetingResponse,
    MeetingUpdateRequest,
)
from app.modules.meetings.service import CustomerNotFoundForMeetingError, MeetingNotFoundError, MeetingService

router = APIRouter(prefix="/meetings", tags=["meetings"])


def _meeting_to_response(meeting) -> MeetingResponse:
    return MeetingResponse(
        id=meeting.id,
        customer_id=meeting.customer_id,
        created_by_user_id=meeting.created_by_user_id,
        title=meeting.title,
        meeting_at=meeting.meeting_at,
        created_at=meeting.created_at,
        updated_at=meeting.updated_at,
    )


@router.post(
    "",
    response_model=MeetingResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_meeting(
    payload: MeetingCreateRequest,
    current_user: User = Depends(get_current_user),
    service: MeetingService = Depends(get_meeting_service),
) -> MeetingResponse:
    try:
        meeting = service.create_meeting(
            customer_id=payload.customer_id,
            created_by_user_id=current_user.id,
            title=payload.title,
            meeting_at=payload.meeting_at,
        )
    except CustomerNotFoundForMeetingError:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Customer not found",
        )

    return _meeting_to_response(meeting)


@router.get(
    "",
    response_model=MeetingListResponse,
    status_code=status.HTTP_200_OK,
)
def list_meetings(
    customer_id: uuid.UUID | None = Query(default=None),
    current_user: User = Depends(get_current_user),
    service: MeetingService = Depends(get_meeting_service),
) -> MeetingListResponse:
    meetings = service.list_meetings(user_id=current_user.id, customer_id=customer_id)
    items = [_meeting_to_response(m) for m in meetings]
    return MeetingListResponse(meetings=items, count=len(items))


@router.get(
    "/{meeting_id}",
    response_model=MeetingResponse,
    status_code=status.HTTP_200_OK,
)
def get_meeting(
    meeting_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: MeetingService = Depends(get_meeting_service),
) -> MeetingResponse:
    try:
        meeting = service.get_meeting(meeting_id=meeting_id, user_id=current_user.id)
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")

    return _meeting_to_response(meeting)


@router.patch(
    "/{meeting_id}",
    response_model=MeetingResponse,
    status_code=status.HTTP_200_OK,
)
def update_meeting(
    meeting_id: uuid.UUID,
    payload: MeetingUpdateRequest,
    current_user: User = Depends(get_current_user),
    service: MeetingService = Depends(get_meeting_service),
) -> MeetingResponse:
    try:
        meeting = service.update_meeting(
            meeting_id=meeting_id,
            user_id=current_user.id,
            title=payload.title,
            meeting_at=payload.meeting_at,
        )
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")

    return _meeting_to_response(meeting)


@router.delete(
    "/{meeting_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_meeting(
    meeting_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: MeetingService = Depends(get_meeting_service),
) -> None:
    try:
        service.delete_meeting(meeting_id=meeting_id, user_id=current_user.id)
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")
