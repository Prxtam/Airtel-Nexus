from __future__ import annotations

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.security import create_access_token, hash_password, verify_password
from app.core.security.jwt import JwtToken
from app.infrastructure.db.models.user import User
from app.modules.auth.repository import UserRepository


class UserAlreadyExistsError(Exception):
    pass


class InvalidCredentialsError(Exception):
    pass


class UserService:
    def __init__(self, db: Session, users: UserRepository):
        self._db = db
        self._users = users

    def authenticate_user(self, *, email: str, plain_password: str) -> JwtToken:
        """Validate credentials and return a signed JWT access token.

        Raises ``InvalidCredentialsError`` for bad email or password (same
        error to prevent user-enumeration).
        """
        normalized_email = email.strip().lower()

        user = self._users.get_by_email(normalized_email)
        if user is None:
            raise InvalidCredentialsError("Invalid email or password")

        if not verify_password(plain_password, user.password_hash):
            raise InvalidCredentialsError("Invalid email or password")

        if not getattr(user, "is_active", True):
            raise InvalidCredentialsError("Invalid email or password")

        roles = [r.name for r in user.roles] if user.roles else []

        return create_access_token(subject=str(user.id), roles=roles)

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
