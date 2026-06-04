from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, Field

from app.infrastructure.db.models.enums import TaskPriority, TaskStatus


class TaskCreateRequest(BaseModel):
    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=2000)
    priority: TaskPriority = Field(default=TaskPriority.medium)
    due_at: datetime | None = Field(default=None)


class TaskResponse(BaseModel):
    id: uuid.UUID
    user_id: uuid.UUID
    title: str
    description: str | None = None
    priority: TaskPriority
    status: TaskStatus
    due_at: datetime | None = None
    completed_at: datetime | None = None
    created_at: datetime
    updated_at: datetime


class TaskListResponse(BaseModel):
    tasks: list[TaskResponse]
    count: int
