from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.models.enums import TaskPriority, TaskStatus
from app.infrastructure.db.models.task import Task


class SqlAlchemyTaskRepository:
    def __init__(self, db: Session):
        self._db = db

    def get_by_id(self, task_id: uuid.UUID) -> Task | None:
        return self._db.get(Task, task_id)

    def list_by_user(self, user_id: uuid.UUID, *, status: TaskStatus | None = None) -> list[Task]:
        stmt = select(Task).where(Task.user_id == user_id)

        if status is not None:
            stmt = stmt.where(Task.status == status)

        stmt = stmt.order_by(Task.created_at.desc())

        return list(self._db.execute(stmt).scalars().all())

    def list_scoped(self, allowed_user_ids: list[uuid.UUID] | None = None, *, status: TaskStatus | None = None) -> list[Task]:
        stmt = select(Task)
        if allowed_user_ids is not None:
            stmt = stmt.where(Task.user_id.in_(allowed_user_ids))

        if status is not None:
            stmt = stmt.where(Task.status == status)

        stmt = stmt.order_by(Task.created_at.desc())

        return list(self._db.execute(stmt).scalars().all())

    def create_task(
        self,
        *,
        user_id: uuid.UUID,
        title: str,
        description: str | None,
        priority: TaskPriority,
        due_at: datetime | None,
    ) -> Task:
        task = Task(
            user_id=user_id,
            title=title,
            description=description,
            priority=priority,
            due_at=due_at,
        )
        self._db.add(task)
        self._db.flush()
        return task

    def complete_task(self, task: Task, completed_at: datetime) -> Task:
        task.status = TaskStatus.completed
        task.completed_at = completed_at
        self._db.flush()
        return task
