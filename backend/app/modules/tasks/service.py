from __future__ import annotations

import uuid
from datetime import datetime

from sqlalchemy.orm import Session

from app.infrastructure.db.models.enums import TaskPriority, TaskStatus
from app.infrastructure.db.models.task import Task
from app.modules.tasks.repository import TaskRepository


class TaskNotFoundError(Exception):
    pass


class TaskService:
    def __init__(self, db: Session, tasks: TaskRepository):
        self._db = db
        self._tasks = tasks

    def create_task(
        self,
        *,
        user_id: uuid.UUID,
        title: str,
        description: str | None,
        priority: TaskPriority,
        due_at: datetime | None,
    ) -> Task:
        task = self._tasks.create_task(
            user_id=user_id,
            title=title,
            description=description,
            priority=priority,
            due_at=due_at,
        )
        self._db.commit()
        self._db.refresh(task)
        return task

    def list_tasks(self, *, user_id: uuid.UUID, status: TaskStatus | None = None) -> list[Task]:
        return self._tasks.list_by_user(user_id, status=status)

    def get_task(self, *, task_id: uuid.UUID, user_id: uuid.UUID) -> Task:
        """Return a task owned by the user, or raise TaskNotFoundError."""
        task = self._tasks.get_by_id(task_id)
        if task is None or task.user_id != user_id:
            raise TaskNotFoundError("Task not found")
        return task
