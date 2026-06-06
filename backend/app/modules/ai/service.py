import uuid

from sqlalchemy.orm import Session

from app.infrastructure.ai.llm_client import LLMClient
from app.modules.customers.repository import CustomerRepository
from app.modules.customers.service import CustomerNotFoundError
from app.modules.meeting_notes.repository import MeetingNoteRepository
from app.modules.meetings.repository import MeetingRepository
from app.modules.meetings.service import MeetingNotFoundError


class AIService:
    def __init__(
        self,
        db: Session,
        llm: LLMClient,
        meetings: MeetingRepository,
        notes: MeetingNoteRepository,
        customers: CustomerRepository,
    ):
        self._db = db
        self._llm = llm
        self._meetings = meetings
        self._notes = notes
        self._customers = customers

    def _get_meeting_context(self, meeting_id: uuid.UUID, user_id: uuid.UUID) -> str:
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or meeting.created_by_user_id != user_id:
            raise MeetingNotFoundError("Meeting not found")

        # Fetch all notes for the meeting
        notes = self._notes.list_notes_by_meeting_owner(user_id=user_id, meeting_id=meeting_id)
        
        if not notes:
            return ""

        # Concatenate notes for the LLM
        notes_content = "\n\n".join([f"Note ({n.created_at.strftime('%Y-%m-%d %H:%M')}):\n{n.note_text}" for n in notes])
        return notes_content

    def generate_meeting_summary(self, meeting_id: uuid.UUID, user_id: uuid.UUID) -> str:
        notes_content = self._get_meeting_context(meeting_id, user_id)
        if not notes_content:
            return "No notes available to summarize."
        return self._llm.generate_meeting_summary(notes_content)

    def extract_action_items(self, meeting_id: uuid.UUID, user_id: uuid.UUID) -> list[str]:
        notes_content = self._get_meeting_context(meeting_id, user_id)
        if not notes_content:
            return ["No notes available to extract action items."]
        return self._llm.extract_action_items(notes_content)

    def draft_follow_up_email(self, meeting_id: uuid.UUID, user_id: uuid.UUID) -> str:
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or meeting.created_by_user_id != user_id:
            raise MeetingNotFoundError("Meeting not found")

        notes_content = self._get_meeting_context(meeting_id, user_id)
        if not notes_content:
            return "No notes available to draft an email."
            
        customer = self._customers.get_by_id(meeting.customer_id)
        customer_name = customer.name if customer else "Customer"
        meeting_title = meeting.title or "Recent Meeting"

        return self._llm.draft_follow_up_email(customer_name, meeting_title, notes_content)

    def generate_customer_insights(self, customer_id: uuid.UUID, user_id: uuid.UUID) -> str:
        customer = self._customers.get_by_id(customer_id)
        if customer is None:
            raise CustomerNotFoundError("Customer not found")

        meetings = self._meetings.list_by_user(user_id=user_id, customer_id=customer_id)
        
        context_lines = []
        context_lines.append(f"Customer Name: {customer.name}")
        context_lines.append(f"Customer Since: {customer.created_at.strftime('%Y-%m-%d')}")
        context_lines.append(f"Total Meetings: {len(meetings)}")
        context_lines.append("\n--- Meeting History & Notes ---")
        
        for m in meetings:
            context_lines.append(f"\nMeeting: {m.title or 'Untitled'} (Date: {m.meeting_at.strftime('%Y-%m-%d %H:%M')})")
            notes = self._notes.list_notes_by_meeting_owner(user_id=user_id, meeting_id=m.id)
            if notes:
                for n in notes:
                    context_lines.append(f"  Note ({n.created_at.strftime('%Y-%m-%d %H:%M')}): {n.note_text}")
            else:
                context_lines.append("  (No notes)")

        context_data = "\n".join(context_lines)
        return self._llm.generate_customer_insights(context_data)
