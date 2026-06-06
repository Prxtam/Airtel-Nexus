import uuid

from fastapi import APIRouter, Depends, HTTPException, status

from app.core.di.ai import get_ai_service
from app.core.di.auth import get_current_user
from app.infrastructure.db.models.user import User
from app.modules.ai.schemas import AIActionItemsResponse, AIEmailDraftResponse, AISummaryResponse
from app.modules.ai.service import AIService
from app.modules.customers.service import CustomerNotFoundError
from app.modules.meetings.service import MeetingNotFoundError

router = APIRouter(prefix="/ai", tags=["ai"])


@router.post(
    "/meetings/{meeting_id}/summary",
    response_model=AISummaryResponse,
    status_code=status.HTTP_200_OK,
)
def generate_summary(
    meeting_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: AIService = Depends(get_ai_service),
) -> AISummaryResponse:
    try:
        summary = service.generate_meeting_summary(meeting_id=meeting_id, user_id=current_user.id)
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")
        
    return AISummaryResponse(summary=summary)


@router.post(
    "/meetings/{meeting_id}/actions",
    response_model=AIActionItemsResponse,
    status_code=status.HTTP_200_OK,
)
def extract_actions(
    meeting_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: AIService = Depends(get_ai_service),
) -> AIActionItemsResponse:
    try:
        actions = service.extract_action_items(meeting_id=meeting_id, user_id=current_user.id)
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")
        
    return AIActionItemsResponse(action_items=actions)


@router.post(
    "/meetings/{meeting_id}/email",
    response_model=AIEmailDraftResponse,
    status_code=status.HTTP_200_OK,
)
def draft_email(
    meeting_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: AIService = Depends(get_ai_service),
) -> AIEmailDraftResponse:
    try:
        email = service.draft_follow_up_email(meeting_id=meeting_id, user_id=current_user.id)
    except MeetingNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Meeting not found")
        
    return AIEmailDraftResponse(email_draft=email)

@router.post(
    "/customers/{customer_id}/insights",
    response_model=AISummaryResponse,
    status_code=status.HTTP_200_OK,
)
def generate_customer_insights(
    customer_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: AIService = Depends(get_ai_service),
) -> AISummaryResponse:
    try:
        insights = service.generate_customer_insights(customer_id=customer_id, user_id=current_user.id)
    except CustomerNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
        
    return AISummaryResponse(summary=insights)
