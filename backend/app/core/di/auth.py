from __future__ import annotations

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.infrastructure.repositories.user_repository import SqlAlchemyUserRepository
from app.modules.auth.service import UserService


def get_user_repository(db: Session = Depends(get_db_session)) -> SqlAlchemyUserRepository:
    return SqlAlchemyUserRepository(db)


def get_user_service(
    db: Session = Depends(get_db_session),
    users: SqlAlchemyUserRepository = Depends(get_user_repository),
) -> UserService:
    return UserService(db=db, users=users)
