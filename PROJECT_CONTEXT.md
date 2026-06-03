# Airtel B2B Sales Assistant

## Objective

Mobile and web platform for Airtel B2B Sales and Account Managers.

Features:

* Authentication
* Task Management
* Meeting Notes
* Customer Information
* AI Sales Assistant (future)

## Tech Stack

Backend:

* FastAPI
* PostgreSQL
* SQLAlchemy
* Alembic
* Pydantic v2
* JWT
* bcrypt

Frontend:

* Flutter (planned)

## Current Status

Completed:

* PostgreSQL setup
* FastAPI startup
* Health endpoint
* SQLAlchemy models
* JWT utilities
* Password hashing utilities
* Authentication schemas

Verified:

* Database connectivity
* JWT generation
* JWT validation
* Password hashing

GitHub:

* Repository initialized
* Commits pushed

## Architecture Rules

* Use repository layer
* Use service layer
* Use Pydantic schemas
* Use SQLAlchemy ORM
* Do not rewrite architecture
* Implement incrementally
* Stop after each feature and provide testing instructions

## Next Task

Implement:

* UserRepository
* UserService
* POST /auth/register
