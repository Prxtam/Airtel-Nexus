from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy.orm import Session

from app.infrastructure.db.models.meeting import Meeting
from app.modules.customers.repository import CustomerRepository
from app.modules.meetings.repository import MeetingRepository


class MeetingNotFoundError(Exception):
    pass


class CustomerNotFoundForMeetingError(Exception):
    pass


class MeetingService:
    def __init__(self, db: Session, meetings: MeetingRepository, customers: CustomerRepository):
        self._db = db
        self._meetings = meetings
        self._customers = customers

    def create_meeting(
        self,
        *,
        customer_id: uuid.UUID,
        created_by_user_id: uuid.UUID,
        title: str | None,
        meeting_at: datetime,
    ) -> Meeting:
        customer = self._customers.get_by_id(customer_id)
        if customer is None:
            raise CustomerNotFoundForMeetingError("Customer not found")

        meeting = self._meetings.create_meeting(
            customer_id=customer_id,
            created_by_user_id=created_by_user_id,
            title=title,
            meeting_at=meeting_at,
        )
        self._db.commit()
        self._db.refresh(meeting)
        return meeting

    def list_meetings(
        self,
        *,
        user_id: uuid.UUID,
        customer_id: uuid.UUID | None = None,
    ) -> list[Meeting]:
        return self._meetings.list_by_user(user_id, customer_id=customer_id)

    def get_meeting(self, *, meeting_id: uuid.UUID, user_id: uuid.UUID) -> Meeting:
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or meeting.created_by_user_id != user_id:
            raise MeetingNotFoundError("Meeting not found")
        return meeting

    def update_meeting(
        self,
        *,
        meeting_id: uuid.UUID,
        user_id: uuid.UUID,
        title: str | None = None,
        meeting_at: datetime | None = None,
    ) -> Meeting:
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or meeting.created_by_user_id != user_id:
            raise MeetingNotFoundError("Meeting not found")

        if title is not None:
            meeting.title = title
        if meeting_at is not None:
            meeting.meeting_at = meeting_at

        self._db.commit()
        self._db.refresh(meeting)
        return meeting

    def delete_meeting(self, *, meeting_id: uuid.UUID, user_id: uuid.UUID) -> None:
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or meeting.created_by_user_id != user_id:
            raise MeetingNotFoundError("Meeting not found")

        self._meetings.delete_meeting(meeting)
        self._db.commit()
