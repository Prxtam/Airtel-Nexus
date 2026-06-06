from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, Field


class CustomerCreateRequest(BaseModel):
    name: str = Field(min_length=1, max_length=250)


class CustomerUpdateRequest(BaseModel):
    name: str | None = Field(default=None, min_length=1, max_length=250)


class CustomerResponse(BaseModel):
    id: uuid.UUID
    owner_id: uuid.UUID | None = None
    name: str
    created_at: datetime
    updated_at: datetime


class CustomerListResponse(BaseModel):
    customers: list[CustomerResponse]
    count: int
