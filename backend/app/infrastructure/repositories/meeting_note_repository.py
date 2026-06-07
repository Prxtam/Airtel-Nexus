from __future__ import annotations

import uuid

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.models.meeting import Meeting
from app.infrastructure.db.models.meeting_note import MeetingNote


class SqlAlchemyMeetingNoteRepository:
    def __init__(self, db: Session):
        self._db = db

    def get_by_id(self, note_id: uuid.UUID) -> MeetingNote | None:
        return self._db.get(MeetingNote, note_id)

    def list_scoped(
        self,
        *,
        allowed_user_ids: list[uuid.UUID] | None = None,
        meeting_id: uuid.UUID | None = None,
    ) -> list[MeetingNote]:
        stmt = select(MeetingNote).join(Meeting)
        if allowed_user_ids is not None:
            stmt = stmt.where(Meeting.created_by_user_id.in_(allowed_user_ids))

        if meeting_id is not None:
            stmt = stmt.where(MeetingNote.meeting_id == meeting_id)

        stmt = stmt.order_by(MeetingNote.created_at.desc())

        return list(self._db.execute(stmt).scalars().all())

    def create_note(
        self,
        *,
        meeting_id: uuid.UUID,
        author_user_id: uuid.UUID,
        note_text: str,
    ) -> MeetingNote:
        note = MeetingNote(
            meeting_id=meeting_id,
            author_user_id=author_user_id,
            note_text=note_text,
        )
        self._db.add(note)
        self._db.flush()
        return note

    def delete_note(self, note: MeetingNote) -> None:
        self._db.delete(note)
        self._db.flush()
