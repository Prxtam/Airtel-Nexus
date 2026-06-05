import os
from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.core.di.customers import get_customer_repository
from app.core.di.meetings import get_meeting_repository
from app.core.di.meeting_notes import get_meeting_note_repository
from app.infrastructure.ai.llm_client import LLMClient
from app.infrastructure.ai.mock_client import MockLLMClient
from app.infrastructure.ai.openai_client import OpenAIClient
from app.modules.ai.service import AIService
from app.modules.customers.repository import CustomerRepository
from app.modules.meeting_notes.repository import MeetingNoteRepository
from app.modules.meetings.repository import MeetingRepository

def get_llm_client() -> LLMClient:
    """
    Returns the appropriate LLMClient based on configuration.
    Currently defaults to MockLLMClient for Phase 6A.
    To enable OpenAI, set USE_OPENAI=true and provide OPENAI_API_KEY in the environment.
    """
    use_openai = os.environ.get("USE_OPENAI", "false").lower() == "true"
    
    if use_openai:
        return OpenAIClient()
        
    return MockLLMClient()

def get_ai_service(
    db: Session = Depends(get_db_session),
    llm: LLMClient = Depends(get_llm_client),
    meetings: MeetingRepository = Depends(get_meeting_repository),
    notes: MeetingNoteRepository = Depends(get_meeting_note_repository),
    customers: CustomerRepository = Depends(get_customer_repository),
) -> AIService:
    return AIService(
        db=db,
        llm=llm,
        meetings=meetings,
        notes=notes,
        customers=customers
    )
