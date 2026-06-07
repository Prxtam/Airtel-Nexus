from __future__ import annotations

import uuid
from typing import Protocol

from app.infrastructure.db.models.meeting_note import MeetingNote


class MeetingNoteRepository(Protocol):
    def get_by_id(self, note_id: uuid.UUID) -> MeetingNote | None: ...

    def list_scoped(
        self,
        *,
        allowed_user_ids: list[uuid.UUID] | None = None,
        meeting_id: uuid.UUID | None = None,
    ) -> list[MeetingNote]: ...

    def create_note(
        self,
        *,
        meeting_id: uuid.UUID,
        author_user_id: uuid.UUID,
        note_text: str,
    ) -> MeetingNote: ...

    def delete_note(self, note: MeetingNote) -> None: ...
