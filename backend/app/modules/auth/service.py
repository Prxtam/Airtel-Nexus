from __future__ import annotations

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.security import hash_password
from app.infrastructure.db.models.user import User
from app.modules.auth.repository import UserRepository


class UserAlreadyExistsError(Exception):
    pass


class UserService:
    def __init__(self, db: Session, users: UserRepository):
        self._db = db
        self._users = users

    def register_user(self, *, email: str, plain_password: str, full_name: str | None) -> User:
        normalized_email = email.strip().lower()

        existing = self._users.get_by_email(normalized_email)
        if existing is not None:
            raise UserAlreadyExistsError("Email already registered")

        password_hash = hash_password(plain_password)

        try:
            user = self._users.create_user(
                email=normalized_email,
                password_hash=password_hash,
                full_name=full_name,
            )
            self._db.commit()
            self._db.refresh(user)
            return user
        except IntegrityError:
            self._db.rollback()
            # Handles race conditions where another request created the same email.
            raise UserAlreadyExistsError("Email already registered")
