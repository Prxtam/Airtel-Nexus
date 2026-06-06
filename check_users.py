import sys
import os

# Add backend to path
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), 'backend')))

from app.infrastructure.db.session import get_sessionmaker
from app.infrastructure.db.models.user import User
from sqlalchemy import select

def check_users():
    SessionLocal = get_sessionmaker()
    with SessionLocal() as db:
        stmt = select(User)
        users = db.execute(stmt).scalars().all()
        
        print(f"1. How many users currently exist? {len(users)}")
        
        print("\n2. User details:")
        has_admin = False
        has_cbh = False
        has_zsm = False
        
        bootstrap_admin_found = False
        
        for u in users:
            roles = [r.name for r in u.roles]
            print(f"  - Email: {u.email}")
            print(f"    Username (Full Name): {u.full_name}")
            print(f"    Roles: {roles}")
            print(f"    Manager ID: {u.manager_id}")
            print(f"    Active: {u.is_active}")
            print("-" * 40)
            
            if 'admin' in roles:
                has_admin = True
                if u.email == 'admin@airtel.com':
                    bootstrap_admin_found = True
            if 'circle_business_head' in roles:
                has_cbh = True
            if 'zonal_sales_manager' in roles:
                has_zsm = True
                
        print(f"\n3. Was the bootstrap admin account successfully created? {'Yes' if bootstrap_admin_found else 'No'}")
        
        print("\n4. Do any users currently have:")
        print(f"   admin: {'Yes' if has_admin else 'No'}")
        print(f"   circle_business_head: {'Yes' if has_cbh else 'No'}")
        print(f"   zonal_sales_manager: {'Yes' if has_zsm else 'No'}")

if __name__ == "__main__":
    check_users()
