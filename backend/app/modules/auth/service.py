from __future__ import annotations

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from app.core.security import create_access_token, hash_password, verify_password
from app.core.security.jwt import JwtToken
from app.infrastructure.db.models.user import User
from app.modules.auth.repository import UserRepository


class UserAlreadyExistsError(Exception):
    pass

class InvalidManagerAssignmentError(Exception):
    pass


class InvalidCredentialsError(Exception):
    pass


class UserService:
    def __init__(self, db: Session, users: UserRepository):
        self._db = db
        self._users = users

    def authenticate_user(self, *, email: str, plain_password: str) -> JwtToken:
        """Validate credentials and return a signed JWT access token.

        Raises ``InvalidCredentialsError`` for bad email or password (same
        error to prevent user-enumeration).
        """
        normalized_email = email.strip().lower()

        user = self._users.get_by_email(normalized_email)
        if user is None:
            raise InvalidCredentialsError("Invalid email or password")

        if not verify_password(plain_password, user.password_hash):
            raise InvalidCredentialsError("Invalid email or password")

        if not getattr(user, "is_active", True):
            raise InvalidCredentialsError("Invalid email or password")

        roles = [r.name for r in user.roles] if user.roles else []

        return create_access_token(subject=str(user.id), roles=roles)

    def register_user(self, *, email: str, plain_password: str, full_name: str | None) -> User:
        normalized_email = email.strip().lower()

        existing = self._users.get_by_email(normalized_email)
        if existing is not None:
            raise UserAlreadyExistsError("Email already registered")

        password_hash = hash_password(plain_password)

        try:
            user = self._users.create_user(
                email=normalized_email,
                password_hash=password_hash,
                full_name=full_name,
            )
            self._db.commit()
            self._db.refresh(user)
            return user
        except IntegrityError:
            self._db.rollback()
            # Handles race conditions where another request created the same email.
            raise UserAlreadyExistsError("Email already registered")

    import uuid
    def assign_manager(self, user_id: uuid.UUID, manager_id: uuid.UUID | None) -> User:
        user = self._users.get_by_id(user_id)
        if not user:
            raise ValueError("User not found")
            
        if manager_id is None:
            user.manager_id = None
            self._db.commit()
            self._db.refresh(user)
            return user
            
        if user.id == manager_id:
            raise InvalidManagerAssignmentError("A user cannot be their own manager")
            
        manager = self._users.get_by_id(manager_id)
        if not manager:
            raise ValueError("Manager not found")
            
        # 1. Circular hierarchy protection
        subordinates = self._users.get_all_subordinates(user.id)
        if any(sub.id == manager_id for sub in subordinates):
            raise InvalidManagerAssignmentError("Manager assignment would create a circular reporting structure")
            
        # 2. Role compatibility validation
        user_roles = [r.name for r in user.roles]
        manager_roles = [r.name for r in manager.roles]
        
        if "account_manager" in user_roles:
            if "zonal_sales_manager" not in manager_roles and "admin" not in manager_roles:
                raise InvalidManagerAssignmentError("Account Managers must report to Zonal Sales Managers")
        elif "zonal_sales_manager" in user_roles:
            if "circle_business_head" not in manager_roles and "admin" not in manager_roles:
                raise InvalidManagerAssignmentError("Zonal Sales Managers must report to Circle Business Heads")
        
        user.manager_id = manager_id
        self._db.commit()
        self._db.refresh(user)
        return user

    def update_status(self, user_id: uuid.UUID, is_active: bool) -> User:
        user = self._users.get_by_id(user_id)
        if not user:
            raise ValueError("User not found")
        user.is_active = is_active
        self._db.commit()
        self._db.refresh(user)
        return user

    def assign_roles(self, user_id: uuid.UUID, roles: list[str]) -> User:
        user = self._users.get_by_id(user_id)
        if not user:
            raise ValueError("User not found")
            
        from app.infrastructure.db.models.role import Role
        from sqlalchemy import select
        
        stmt = select(Role).where(Role.name.in_(roles))
        role_objs = list(self._db.execute(stmt).scalars().all())
        
        user.roles = role_objs
        self._db.commit()
        self._db.refresh(user)
        return user

    def reset_password(self, user_id: uuid.UUID, new_password: str) -> User:
        user = self._users.get_by_id(user_id)
        if not user:
            raise ValueError("User not found")
            
        password_hash = hash_password(new_password)
        user.password_hash = password_hash
        self._db.commit()
        self._db.refresh(user)
        return user

    def list_all(self) -> list[User]:
        return self._users.list_all()
