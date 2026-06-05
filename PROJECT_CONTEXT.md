# Airtel B2B Sales Assistant - Project Context

## Project Goal

Build a production-style Airtel Enterprise Sales Assistant mobile application for B2B account managers.

The application helps account managers manage:

* Customers
* Tasks
* Meetings
* Meeting Notes

Future phases may include:

* Role-based access control
* AI assistant integration
* Dashboard analytics
* Search and filtering
* UI/UX redesign

---

## Tech Stack

### Backend

* FastAPI
* PostgreSQL
* SQLAlchemy
* Alembic
* JWT Authentication
* bcrypt password hashing

### Frontend

* Flutter
* Riverpod
* GoRouter
* Dio
* Flutter Secure Storage
* JsonSerializable

---

## Current Architecture

### Backend

Implemented modules:

#### Authentication

* Login
* JWT token generation
* Protected endpoints

#### Customers

Endpoints:

* GET /customers
* POST /customers
* GET /customers/{id}
* PATCH /customers/{id}
* DELETE /customers/{id}

#### Tasks

Endpoints:

* POST /tasks
* GET /tasks
* GET /tasks/{id}
* POST /tasks/{id}/complete

Task completion is intentionally implemented as an action endpoint rather than a generic PATCH.

Completion endpoint is idempotent.

#### Meetings

CRUD implemented.

#### Meeting Notes

CRUD implemented.

---

## Frontend Modules

### Phase 1 - Authentication

Status: Complete

Features:

* Login
* Token persistence
* Auto-login after restart
* Protected routes

### Phase 2 - Customers

Status: Complete

Features:

* Customer list
* Customer detail
* Create customer
* Edit customer
* Delete customer

### Phase 3 - Tasks

Status: Complete

Features:

* Task list
* Task detail
* Create task
* Mark task complete
* Pending/completed filters
* Confirmation before completion

Known business rule:

* Completed tasks cannot currently be reverted.

### Phase 4 - Meetings & Notes

Status: Complete

Features:

* Meeting list
* Schedule meeting
* Edit meeting
* Delete meeting
* Meeting notes
* Create note
* Edit note
* Delete note

Meeting creation requires an existing customer.

No-customer empty state implemented.

---

## Dashboard

Live metrics:

* Total Customers
* Pending Tasks
* Upcoming Meetings

Placeholder:

* Recent Notes

Navigation:

* Add Customer
* View Customers
* Create Task
* View Tasks
* Schedule Meeting
* View Meetings

---

## Important Business Decisions

### Tasks

Current model:

Users can create personal tasks.

Users can complete their own tasks.

Future enhancement planned:

* Employee-created tasks:

  * Editable
  * Deletable

* Manager-assigned tasks:

  * Not editable by employee
  * Not deletable by employee
  * Can only be completed

This role-based permission system is NOT yet implemented.

### Meetings

Customer selection uses a dropdown.

Searchable customer picker was intentionally deferred.

---

## Manual Verification Status

All phases manually tested on physical Android device.

Verified:

* Authentication
* Customer CRUD
* Task creation
* Task completion
* Dashboard metrics
* Meeting CRUD
* Meeting Notes CRUD
* Navigation flows

Application currently functions end-to-end.

---

## Current Priority

Do NOT redesign architecture.

Core CRUD foundation is complete.

Next development should focus on one of:

1. UI/UX redesign (recommended)
2. Role-based permissions
3. Search and filtering
4. AI assistant integration
5. Advanced dashboard analytics

Existing functionality should remain stable while future phases are added.



Phase 5 Completed

Features:
- Customer search
- Customer sorting
- Task search
- Task priority filtering
- Meeting search
- Meeting customer filtering
- Meeting time filtering
- Dashboard completed-task analytics

Architecture:
- Client-side filtering via Riverpod derived providers
- AutoDispose filter state
- Zero backend changes
- All features manually tested on Android device
