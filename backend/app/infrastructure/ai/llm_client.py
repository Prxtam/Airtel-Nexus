from typing import Protocol

class LLMClient(Protocol):
    def generate_meeting_summary(self, notes_content: str) -> str:
        """Generates a concise summary, key discussion points, and decisions."""
        ...

    def extract_action_items(self, notes_content: str) -> list[str]:
        """Extracts actionable follow-ups and ownership from meeting notes."""
        ...

    def draft_follow_up_email(self, customer_name: str, meeting_title: str, notes_content: str) -> str:
        """Generates a professional follow-up email draft based on the meeting notes."""
        ...

    def generate_customer_insights(self, context_data: str) -> str:
        """Generates a comprehensive summary of a customer relationship."""
        ...
