from __future__ import annotations

import anyio
from fastapi import APIRouter, Depends
from sqlalchemy import Engine

from app.api.schemas.health import HealthResponse
from app.infrastructure.db.health import validate_database_connectivity
from app.infrastructure.db.session import get_engine

router = APIRouter(tags=["health"])


def engine_dep() -> Engine:
    return get_engine()


@router.get("/health", response_model=HealthResponse)
async def health(engine: Engine = Depends(engine_dep)) -> HealthResponse:
    await anyio.to_thread.run_sync(validate_database_connectivity, engine)
    return HealthResponse(status="ok", database="ok")
