from __future__ import annotations

import uuid

from sqlalchemy.orm import Session

from app.infrastructure.db.models.meeting_note import MeetingNote
from app.modules.meetings.repository import MeetingRepository
from app.modules.meeting_notes.repository import MeetingNoteRepository
from app.core.di.rbac import is_in_rbac_scope


class MeetingNoteNotFoundError(Exception):
    pass


class MeetingNotFoundForNoteError(Exception):
    pass


class MeetingNoteService:
    def __init__(
        self,
        db: Session,
        notes: MeetingNoteRepository,
        meetings: MeetingRepository,
    ):
        self._db = db
        self._notes = notes
        self._meetings = meetings

    def create_note(
        self,
        *,
        meeting_id: uuid.UUID,
        author_user_id: uuid.UUID,
        allowed_user_ids: list[uuid.UUID] | None,
        note_text: str,
    ) -> MeetingNote:
        # Validate meeting existence and ownership
        meeting = self._meetings.get_by_id(meeting_id)
        if meeting is None or not is_in_rbac_scope(meeting.created_by_user_id, allowed_user_ids):
            raise MeetingNotFoundForNoteError("Meeting not found")

        note = self._notes.create_note(
            meeting_id=meeting_id,
            author_user_id=author_user_id,
            note_text=note_text,
        )
        self._db.commit()
        self._db.refresh(note)
        return note

    def list_notes(
        self,
        *,
        allowed_user_ids: list[uuid.UUID] | None = None,
        meeting_id: uuid.UUID | None = None,
    ) -> list[MeetingNote]:
        # A user should only be able to access notes belonging to meetings in their scope.
        return self._notes.list_scoped(allowed_user_ids=allowed_user_ids, meeting_id=meeting_id)

    def get_note(self, *, note_id: uuid.UUID, allowed_user_ids: list[uuid.UUID] | None) -> MeetingNote:
        note = self._notes.get_by_id(note_id)
        if note is None:
            raise MeetingNoteNotFoundError("Meeting note not found")

        # Validate that the meeting is in scope
        if not is_in_rbac_scope(note.meeting.created_by_user_id, allowed_user_ids):
            raise MeetingNoteNotFoundError("Meeting note not found")

        return note

    def update_note(
        self,
        *,
        note_id: uuid.UUID,
        user_id: uuid.UUID,
        allowed_user_ids: list[uuid.UUID] | None,
        note_text: str | None = None,
    ) -> MeetingNote:
        note = self._notes.get_by_id(note_id)
        if note is None:
            raise MeetingNoteNotFoundError("Meeting note not found")

        # Ensure only a manager in scope can access it
        if not is_in_rbac_scope(note.meeting.created_by_user_id, allowed_user_ids):
            raise MeetingNoteNotFoundError("Meeting note not found")

        # In RBAC, if it's in scope, allow the update.
        # No strict author_user_id == user_id check here, allowing ZSMs to update team notes.

        if note_text is not None:
            note.note_text = note_text

        self._db.commit()
        self._db.refresh(note)
        return note

    def delete_note(self, *, note_id: uuid.UUID, user_id: uuid.UUID, allowed_user_ids: list[uuid.UUID] | None) -> None:
        note = self._notes.get_by_id(note_id)
        if note is None:
            raise MeetingNoteNotFoundError("Meeting note not found")

        # Ensure only a manager in scope can access it
        if not is_in_rbac_scope(note.meeting.created_by_user_id, allowed_user_ids):
            raise MeetingNoteNotFoundError("Meeting note not found")

        self._notes.delete_note(note)
        self._db.commit()
