from __future__ import annotations

import uuid

from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.infrastructure.db.base import Base
from app.infrastructure.db.models.mixins import SoftActiveMixin, TimestampMixin, UUIDPrimaryKeyMixin


class User(Base, UUIDPrimaryKeyMixin, TimestampMixin, SoftActiveMixin):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(String(320), nullable=False, unique=True, index=True)
    full_name: Mapped[str | None] = mapped_column(String(200), nullable=True)
    password_hash: Mapped[str] = mapped_column(String(500), nullable=False)

    tasks = relationship(
        "Task",
        back_populates="user",
        cascade="all, delete-orphan",
        passive_deletes=True,
    )

    meetings_created = relationship(
        "Meeting",
        back_populates="created_by",
        passive_deletes=True,
        foreign_keys="Meeting.created_by_user_id",
    )

    meeting_notes = relationship(
        "MeetingNote",
        back_populates="author",
        passive_deletes=True,
        foreign_keys="MeetingNote.author_user_id",
    )

    roles = relationship(
        "Role",
        secondary="user_roles",
        back_populates="users",
        lazy="selectin",
    )
