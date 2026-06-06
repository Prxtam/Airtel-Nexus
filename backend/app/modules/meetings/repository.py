from __future__ import annotations

import uuid

from typing import Protocol

from app.infrastructure.db.models.meeting import Meeting


class MeetingRepository(Protocol):
    def get_by_id(self, meeting_id: uuid.UUID) -> Meeting | None: ...

    def list_by_user(
        self,
        user_id: uuid.UUID,
        *,
        customer_id: uuid.UUID | None = None,
    ) -> list[Meeting]: ...

    def list_scoped(
        self,
        allowed_user_ids: list[uuid.UUID] | None = None,
        *,
        customer_id: uuid.UUID | None = None,
    ) -> list[Meeting]: ...

    def create_meeting(
        self,
        *,
        customer_id: uuid.UUID,
        created_by_user_id: uuid.UUID,
        title: str | None,
        meeting_at: object,
    ) -> Meeting: ...

    def delete_meeting(self, meeting: Meeting) -> None: ...
