from __future__ import annotations

import uuid

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.core.security.jwt import decode_access_token
from app.infrastructure.db.models.user import User
from app.infrastructure.repositories.user_repository import SqlAlchemyUserRepository
from app.modules.auth.service import UserService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/token")

_credentials_exception = HTTPException(
    status_code=status.HTTP_401_UNAUTHORIZED,
    detail="Could not validate credentials",
    headers={"WWW-Authenticate": "Bearer"},
)


def get_user_repository(db: Session = Depends(get_db_session)) -> SqlAlchemyUserRepository:
    return SqlAlchemyUserRepository(db)


def get_user_service(
    db: Session = Depends(get_db_session),
    users: SqlAlchemyUserRepository = Depends(get_user_repository),
) -> UserService:
    return UserService(db=db, users=users)


def get_current_user(
    token: str = Depends(oauth2_scheme),
    repo: SqlAlchemyUserRepository = Depends(get_user_repository),
) -> User:
    """FastAPI dependency – returns the authenticated User or raises 401."""
    try:
        payload = decode_access_token(token)
    except JWTError:
        raise _credentials_exception

    sub: str | None = payload.get("sub")
    if sub is None:
        raise _credentials_exception

    try:
        user_id = uuid.UUID(sub)
    except ValueError:
        raise _credentials_exception

    user = repo.get_by_id(user_id)
    if user is None:
        raise _credentials_exception

    if not getattr(user, "is_active", True):
        raise _credentials_exception

    return user
