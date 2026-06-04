from __future__ import annotations

import uuid
from datetime import datetime

from pydantic import BaseModel, Field


class MeetingNoteCreateRequest(BaseModel):
    meeting_id: uuid.UUID
    note_text: str = Field(min_length=1)


class MeetingNoteUpdateRequest(BaseModel):
    note_text: str | None = Field(default=None, min_length=1)


class MeetingNoteResponse(BaseModel):
    id: uuid.UUID
    meeting_id: uuid.UUID
    author_user_id: uuid.UUID
    note_text: str
    created_at: datetime
    updated_at: datetime


class MeetingNoteListResponse(BaseModel):
    notes: list[MeetingNoteResponse]
    count: int
