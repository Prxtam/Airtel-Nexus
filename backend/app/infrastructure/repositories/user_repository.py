from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.models.user import User


class SqlAlchemyUserRepository:
    def __init__(self, db: Session):
        self._db = db

    def get_by_email(self, email: str) -> User | None:
        stmt = select(User).where(User.email == email)
        return self._db.execute(stmt).scalar_one_or_none()

    def get_by_id(self, user_id: uuid.UUID) -> User | None:
        return self._db.get(User, user_id)

    def create_user(self, *, email: str, password_hash: str, full_name: str | None) -> User:
        user = User(
            email=email,
            password_hash=password_hash,
            full_name=full_name,
            is_active=True,
        )
        self._db.add(user)
        self._db.flush()  # allocate PK
        return user

    def list_all(self) -> list[User]:
        stmt = select(User).order_by(User.created_at.desc())
        return list(self._db.execute(stmt).scalars().all())

    def get_direct_reports(self, manager_id: uuid.UUID) -> list[User]:
        stmt = select(User).where(User.manager_id == manager_id)
        return list(self._db.execute(stmt).scalars().all())

    def get_all_subordinates(self, manager_id: uuid.UUID) -> list[User]:
        # Recursive CTE to get all subordinates down the tree
        hierarchy = select(User.id).where(User.manager_id == manager_id).cte(name="hierarchy", recursive=True)
        hierarchy = hierarchy.union_all(
            select(User.id).where(User.manager_id == hierarchy.c.id)
        )
        stmt = select(User).join(hierarchy, User.id == hierarchy.c.id)
        return list(self._db.execute(stmt).scalars().all())
