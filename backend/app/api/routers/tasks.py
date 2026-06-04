from __future__ import annotations

import uuid

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.core.di.auth import get_current_user
from app.core.di.tasks import get_task_service
from app.infrastructure.db.models.enums import TaskStatus
from app.infrastructure.db.models.user import User
from app.modules.tasks.schemas import TaskCreateRequest, TaskListResponse, TaskResponse
from app.modules.tasks.service import TaskNotFoundError, TaskService

router = APIRouter(prefix="/tasks", tags=["tasks"])


def _task_to_response(task) -> TaskResponse:
    return TaskResponse(
        id=task.id,
        user_id=task.user_id,
        title=task.title,
        description=task.description,
        priority=task.priority,
        status=task.status,
        due_at=task.due_at,
        completed_at=task.completed_at,
        created_at=task.created_at,
        updated_at=task.updated_at,
    )


@router.post(
    "",
    response_model=TaskResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_task(
    payload: TaskCreateRequest,
    current_user: User = Depends(get_current_user),
    service: TaskService = Depends(get_task_service),
) -> TaskResponse:
    task = service.create_task(
        user_id=current_user.id,
        title=payload.title,
        description=payload.description,
        priority=payload.priority,
        due_at=payload.due_at,
    )
    return _task_to_response(task)


@router.get(
    "",
    response_model=TaskListResponse,
    status_code=status.HTTP_200_OK,
)
def list_tasks(
    task_status: TaskStatus | None = Query(default=None, alias="status"),
    current_user: User = Depends(get_current_user),
    service: TaskService = Depends(get_task_service),
) -> TaskListResponse:
    tasks = service.list_tasks(user_id=current_user.id, status=task_status)
    items = [_task_to_response(t) for t in tasks]
    return TaskListResponse(tasks=items, count=len(items))


@router.get(
    "/{task_id}",
    response_model=TaskResponse,
    status_code=status.HTTP_200_OK,
)
def get_task(
    task_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    service: TaskService = Depends(get_task_service),
) -> TaskResponse:
    try:
        task = service.get_task(task_id=task_id, user_id=current_user.id)
    except TaskNotFoundError:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Task not found")

    return _task_to_response(task)
