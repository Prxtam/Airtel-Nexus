from __future__ import annotations

import uuid
from datetime import datetime

from typing import Protocol

from app.infrastructure.db.models.enums import TaskStatus
from app.infrastructure.db.models.task import Task


class TaskRepository(Protocol):
    def get_by_id(self, task_id: uuid.UUID) -> Task | None: ...

    def list_by_user(self, user_id: uuid.UUID, *, status: TaskStatus | None = None) -> list[Task]: ...

    def list_scoped(self, allowed_user_ids: list[uuid.UUID] | None = None, *, status: TaskStatus | None = None) -> list[Task]: ...

    def create_task(
        self,
        *,
        user_id: uuid.UUID,
        title: str,
        description: str | None,
        priority: TaskStatus | None,
        due_at: object | None,
    ) -> Task: ...

    def complete_task(self, task: Task, completed_at: datetime) -> Task: ...
