from __future__ import annotations

import uuid

from sqlalchemy import ForeignKey, Index, Text
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.infrastructure.db.base import Base
from app.infrastructure.db.models.mixins import TimestampMixin, UUIDPrimaryKeyMixin


class MeetingNote(Base, UUIDPrimaryKeyMixin, TimestampMixin):
    __tablename__ = "meeting_notes"

    meeting_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("meetings.id", ondelete="CASCADE"), nullable=False, index=True)
    author_user_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="RESTRICT"), nullable=False, index=True)

    note_text: Mapped[str] = mapped_column(Text, nullable=False)

    meeting = relationship("Meeting", back_populates="notes")
    author = relationship("User", back_populates="meeting_notes", foreign_keys=[author_user_id])


Index("ix_meeting_notes_meeting_author", MeetingNote.meeting_id, MeetingNote.author_user_id)
