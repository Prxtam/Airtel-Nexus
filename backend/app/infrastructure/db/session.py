from __future__ import annotations

from functools import lru_cache
from typing import Generator

from sqlalchemy import Engine, create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.core.config import get_settings


@lru_cache
def get_engine() -> Engine:
    settings = get_settings()

    return create_engine(
        settings.build_database_url_obj(),
        echo=settings.sqlalchemy_echo,
        pool_pre_ping=True,
        pool_size=settings.sqlalchemy_pool_size,
        max_overflow=settings.sqlalchemy_max_overflow,
    )


@lru_cache
def get_sessionmaker() -> sessionmaker[Session]:
    return sessionmaker(
        bind=get_engine(),
        autoflush=False,
        autocommit=False,
        expire_on_commit=False,
    )


def get_db_session() -> Generator[Session, None, None]:
    """FastAPI dependency (yield-based) for a per-request DB session."""

    session_local = get_sessionmaker()
    db = session_local()
    try:
        yield db
    finally:
        db.close()
