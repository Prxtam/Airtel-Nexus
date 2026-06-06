from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.models.meeting import Meeting


class SqlAlchemyMeetingRepository:
    def __init__(self, db: Session):
        self._db = db

    def get_by_id(self, meeting_id: uuid.UUID) -> Meeting | None:
        return self._db.get(Meeting, meeting_id)

    def list_by_user(
        self,
        user_id: uuid.UUID,
        *,
        customer_id: uuid.UUID | None = None,
    ) -> list[Meeting]:
        stmt = select(Meeting).where(Meeting.created_by_user_id == user_id)

        if customer_id is not None:
            stmt = stmt.where(Meeting.customer_id == customer_id)

        stmt = stmt.order_by(Meeting.meeting_at.desc())

        return list(self._db.execute(stmt).scalars().all())

    def list_scoped(
        self,
        allowed_user_ids: list[uuid.UUID] | None = None,
        *,
        customer_id: uuid.UUID | None = None,
    ) -> list[Meeting]:
        stmt = select(Meeting)
        if allowed_user_ids is not None:
            stmt = stmt.where(Meeting.created_by_user_id.in_(allowed_user_ids))
            
        if customer_id is not None:
            stmt = stmt.where(Meeting.customer_id == customer_id)
            
        stmt = stmt.order_by(Meeting.meeting_at.desc())
        return list(self._db.execute(stmt).scalars().all())

    def create_meeting(
        self,
        *,
        customer_id: uuid.UUID,
        created_by_user_id: uuid.UUID,
        title: str | None,
        meeting_at: datetime,
    ) -> Meeting:
        meeting = Meeting(
            customer_id=customer_id,
            created_by_user_id=created_by_user_id,
            title=title,
            meeting_at=meeting_at,
        )
        self._db.add(meeting)
        self._db.flush()
        return meeting

    def delete_meeting(self, meeting: Meeting) -> None:
        self._db.delete(meeting)
        self._db.flush()
