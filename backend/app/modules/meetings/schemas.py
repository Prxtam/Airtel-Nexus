from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, Field


class MeetingCreateRequest(BaseModel):
    customer_id: uuid.UUID
    title: str | None = Field(default=None, max_length=250)
    meeting_at: datetime


class MeetingUpdateRequest(BaseModel):
    title: str | None = Field(default=None, max_length=250)
    meeting_at: datetime | None = None


class MeetingResponse(BaseModel):
    id: uuid.UUID
    customer_id: uuid.UUID
    created_by_user_id: uuid.UUID
    title: str | None = None
    meeting_at: datetime
    created_at: datetime
    updated_at: datetime


class MeetingListResponse(BaseModel):
    meetings: list[MeetingResponse]
    count: int
