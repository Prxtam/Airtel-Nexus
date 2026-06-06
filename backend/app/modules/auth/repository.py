from __future__ import annotations

import uuid
from typing import Protocol

from app.infrastructure.db.models.user import User


class UserRepository(Protocol):
    def get_by_email(self, email: str) -> User | None: ...

    def get_by_id(self, user_id: uuid.UUID) -> User | None: ...

    def create_user(self, *, email: str, password_hash: str, full_name: str | None) -> User: ...

    def list_all(self) -> list[User]: ...

    def get_direct_reports(self, manager_id: uuid.UUID) -> list[User]: ...

    def get_all_subordinates(self, manager_id: uuid.UUID) -> list[User]: ...
