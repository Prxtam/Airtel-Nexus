import uuid
from fastapi import Depends
from app.core.di.auth import get_current_user, get_user_repository
from app.infrastructure.db.models.user import User
from app.infrastructure.repositories.user_repository import SqlAlchemyUserRepository

def get_allowed_user_ids(
    current_user: User = Depends(get_current_user),
    repo: SqlAlchemyUserRepository = Depends(get_user_repository),
) -> list[uuid.UUID] | None:
    """
    Returns the list of user IDs the current user is allowed to view.
    If None, the user can view all (Admin, CBH).
    If a list, the user can view themselves + subordinates (ZSM) or just themselves (AM).
    """
    roles = [r.name for r in current_user.roles] if current_user.roles else []
    
    if "admin" in roles or "circle_business_head" in roles:
        return None  # Unrestricted
        
    allowed_ids = [current_user.id]
    
    if "zonal_sales_manager" in roles:
        subordinates = repo.get_direct_reports(current_user.id) # Or get_all_subordinates depending on depth. ZSM manages AMs, so direct reports is fine.
        for sub in subordinates:
            allowed_ids.append(sub.id)
            
    return allowed_ids

def is_in_rbac_scope(owner_id: uuid.UUID | None, allowed_user_ids: list[uuid.UUID] | None) -> bool:
    """
    Checks whether a resource owner is within the current user's allowed RBAC scope.
    - If allowed_user_ids is None, returns True (Admin/CBH unrestricted access).
    - If owner_id is None, returns False (cannot verify ownership).
    - Otherwise returns True if owner_id is in allowed_user_ids.
    """
    if allowed_user_ids is None:
        return True
    if owner_id is None:
        return False
    return owner_id in allowed_user_ids
