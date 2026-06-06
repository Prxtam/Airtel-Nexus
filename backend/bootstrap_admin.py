import argparse
import sys
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.infrastructure.db.session import get_sessionmaker
from app.infrastructure.db.models.user import User
from app.infrastructure.db.models.role import Role
from app.infrastructure.db.models.user_role import UserRole
from app.core.security import hash_password

def bootstrap_admin(email: str, password: str, full_name: str):
    SessionLocal = get_sessionmaker()
    db: Session = SessionLocal()
    try:
        # Check if user already exists
        user = db.execute(select(User).where(User.email == email)).scalar_one_or_none()
        if not user:
            user = User(
                email=email,
                password_hash=hash_password(password),
                full_name=full_name,
                is_active=True
            )
            db.add(user)
            db.flush()
            print(f"Created new user: {email}")
        else:
            print(f"User {email} already exists. Promoting to admin.")

        # Get admin role
        admin_role = db.execute(select(Role).where(Role.name == "admin")).scalar_one_or_none()
        if not admin_role:
            print("Error: 'admin' role not found in database. Did you run migrations?")
            sys.exit(1)

        # Check if user already has admin role
        user_role = db.execute(select(UserRole).where(UserRole.user_id == user.id, UserRole.role_id == admin_role.id)).scalar_one_or_none()
        if not user_role:
            ur = UserRole(user_id=user.id, role_id=admin_role.id)
            db.add(ur)
            print(f"Assigned 'admin' role to {email}.")
        else:
            print(f"User {email} is already an admin.")

        db.commit()
        print("Bootstrap complete.")

    except Exception as e:
        db.rollback()
        print(f"Error bootstrapping admin: {e}")
        sys.exit(1)
    finally:
        db.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Bootstrap an admin user")
    parser.add_argument("--email", required=True, help="Admin email")
    parser.add_argument("--password", required=True, help="Admin password")
    parser.add_argument("--name", default="Admin", help="Admin full name")
    
    args = parser.parse_args()
    bootstrap_admin(args.email, args.password, args.name)
