from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import DateTime, ForeignKey, Index, String
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.infrastructure.db.base import Base
from app.infrastructure.db.models.mixins import TimestampMixin, UUIDPrimaryKeyMixin


class Meeting(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "meetings"

    customer_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("customers.id", ondelete="CASCADE"), nullable=False, index=True)
    created_by_user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False, index=True)

    title: Mapped[str | None] = mapped_column(String(250), nullable=True)
    meeting_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False, index=True)

    customer = relationship("Customer", back_populates="meetings")
    created_by = relationship("User", back_populates="meetings_created", foreign_keys=[created_by_user_id])

    notes = relationship(
        "MeetingNote",
        back_populates="meeting",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )


Index("ix_meetings_customer_meeting_at", Meeting.customer_id, Meeting.meeting_at)
