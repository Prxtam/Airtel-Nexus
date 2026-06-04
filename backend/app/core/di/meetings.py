from __future__ import annotations

from fastapi import Depends
from sqlalchemy.orm import Session

from app.core.di.customers import get_customer_repository
from app.core.di.db import get_db_session
from app.infrastructure.repositories.customer_repository import SqlAlchemyCustomerRepository
from app.infrastructure.repositories.meeting_repository import SqlAlchemyMeetingRepository
from app.modules.meetings.service import MeetingService


def get_meeting_repository(db: Session = Depends(get_db_session)) -> SqlAlchemyMeetingRepository:
    return SqlAlchemyMeetingRepository(db)


def get_meeting_service(
    db: Session = Depends(get_db_session),
    meetings: SqlAlchemyMeetingRepository = Depends(get_meeting_repository),
    customers: SqlAlchemyCustomerRepository = Depends(get_customer_repository),
) -> MeetingService:
    return MeetingService(db=db, meetings=meetings, customers=customers)
