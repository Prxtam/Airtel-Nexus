from __future__ import annotations

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.db import get_db_session
from app.core.di.meetings import get_meeting_repository
from app.infrastructure.repositories.meeting_note_repository import SqlAlchemyMeetingNoteRepository
from app.infrastructure.repositories.meeting_repository import SqlAlchemyMeetingRepository
from app.modules.meeting_notes.service import MeetingNoteService


def get_meeting_note_repository(
    db: Session = Depends(get_db_session)
) -> SqlAlchemyMeetingNoteRepository:
    return SqlAlchemyMeetingNoteRepository(db)


def get_meeting_note_service(
    db: Session = Depends(get_db_session),
    notes: SqlAlchemyMeetingNoteRepository = Depends(get_meeting_note_repository),
    meetings: SqlAlchemyMeetingRepository = Depends(get_meeting_repository),
) -> MeetingNoteService:
    return MeetingNoteService(db=db, notes=notes, meetings=meetings)
