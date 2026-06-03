from __future__ import annotations

# Import all models here so Alembic can discover them via Base.metadata

from app.infrastructure.db.models.customer import Customer
from app.infrastructure.db.models.meeting import Meeting
from app.infrastructure.db.models.meeting_note import MeetingNote
from app.infrastructure.db.models.role import Role
from app.infrastructure.db.models.task import Task
from app.infrastructure.db.models.user import User
from app.infrastructure.db.models.user_role import UserRole

__all__ = [
    "Customer",
    "Meeting",
    "MeetingNote",
    "Role",
    "Task",
    "User",
    "UserRole",
]
