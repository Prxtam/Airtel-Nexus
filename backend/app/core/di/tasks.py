from __future__ import annotations

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.infrastructure.repositories.task_repository import SqlAlchemyTaskRepository
from app.modules.tasks.service import TaskService


def get_task_repository(db: Session = Depends(get_db_session)) -> SqlAlchemyTaskRepository:
    return SqlAlchemyTaskRepository(db)


def get_task_service(
    db: Session = Depends(get_db_session),
    tasks: SqlAlchemyTaskRepository = Depends(get_task_repository),
) -> TaskService:
    return TaskService(db=db, tasks=tasks)
