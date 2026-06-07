from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.di.auth import get_current_user
from app.core.di.rbac import get_allowed_user_ids
from app.core.di.meeting_notes import get_meeting_note_service
from app.infrastructure.db.models.user import User
from app.modules.meeting_notes.schemas import (
    MeetingNoteCreateRequest,
    MeetingNoteListResponse,
    MeetingNoteResponse,
    MeetingNoteUpdateRequest,
)
from app.modules.meeting_notes.service import (
    MeetingNotFoundForNoteError,
    MeetingNoteNotFoundError,
    MeetingNoteService,
)

router = APIRouter(prefix="/meeting-notes", tags=["meeting-notes"])


def _note_to_response(note) -> MeetingNoteResponse:
    return MeetingNoteResponse(
        id=note.id,
        meeting_id=note.meeting_id,
        author_user_id=note.author_user_id,
        note_text=note.note_text,
        created_at=note.created_at,
        updated_at=note.updated_at,
    )


@router.post(
    "",
    response_model=MeetingNoteResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_note(
    payload: MeetingNoteCreateRequest,
    current_user: User = Depends(get_current_user),
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: MeetingNoteService = Depends(get_meeting_note_service),
) -> MeetingNoteResponse:
    try:
        note = service.create_note(
            meeting_id=payload.meeting_id,
            author_user_id=current_user.id,
            allowed_user_ids=allowed_user_ids,
            note_text=payload.note_text,
        )
    except MeetingNotFoundForNoteError:
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            detail="Meeting not found",
        )

    return _note_to_response(note)


@router.get(
    "",
    response_model=MeetingNoteListResponse,
    status_code=status.HTTP_200_OK,
)
def list_notes(
    meeting_id: uuid.UUID | None = Query(default=None),
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: MeetingNoteService = Depends(get_meeting_note_service),
) -> MeetingNoteListResponse:
    notes = service.list_notes(allowed_user_ids=allowed_user_ids, meeting_id=meeting_id)
    items = [_note_to_response(n) for n in notes]
    return MeetingNoteListResponse(notes=items, count=len(items))


@router.get(
    "/{note_id}",
    response_model=MeetingNoteResponse,
    status_code=status.HTTP_200_OK,
)
def get_note(
    note_id: uuid.UUID,
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: MeetingNoteService = Depends(get_meeting_note_service),
) -> MeetingNoteResponse:
    try:
        note = service.get_note(note_id=note_id, allowed_user_ids=allowed_user_ids)
    except MeetingNoteNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meeting note not found",
        )

    return _note_to_response(note)


@router.patch(
    "/{note_id}",
    response_model=MeetingNoteResponse,
    status_code=status.HTTP_200_OK,
)
def update_note(
    note_id: uuid.UUID,
    payload: MeetingNoteUpdateRequest,
    current_user: User = Depends(get_current_user),
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: MeetingNoteService = Depends(get_meeting_note_service),
) -> MeetingNoteResponse:
    try:
        note = service.update_note(
            note_id=note_id,
            user_id=current_user.id,
            allowed_user_ids=allowed_user_ids,
            note_text=payload.note_text,
        )
    except MeetingNoteNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meeting note not found",
        )

    return _note_to_response(note)


from fastapi import Response

@router.delete(
    "/{note_id}",
    status_code=status.HTTP_204_NO_CONTENT,
    response_class=Response,
    response_model=None,
)
def delete_note(
    note_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    allowed_user_ids: list[uuid.UUID] | None = Depends(get_allowed_user_ids),
    service: MeetingNoteService = Depends(get_meeting_note_service),
) -> None:
    try:
        service.delete_note(note_id=note_id, user_id=current_user.id, allowed_user_ids=allowed_user_ids)
    except MeetingNoteNotFoundError:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Meeting note not found",
        )
