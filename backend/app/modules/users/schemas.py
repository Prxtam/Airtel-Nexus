from typing import List, Optional
from pydantic import BaseModel
import uuid

class UserRoleUpdate(BaseModel):
    role: str

class UserManagerUpdate(BaseModel):
    manager_id: Optional[uuid.UUID]

class UserStatusUpdate(BaseModel):
    is_active: bool

class UserPasswordReset(BaseModel):
    new_password: str

class UserAdminResponse(BaseModel):
    id: uuid.UUID
    email: str
    full_name: Optional[str]
    is_active: bool
    manager_id: Optional[uuid.UUID]
    roles: List[str]
