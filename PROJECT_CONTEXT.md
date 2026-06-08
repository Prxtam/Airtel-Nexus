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


## Phase 6A Complete - AI Sales Assistant

Implemented:
- AI Copilot for Meeting Detail
- Meeting Summary generation
- Action Item extraction
- Follow-up Email drafting
- LLM abstraction layer
- MockLLMClient and OpenAIClient support

Development Note:
- Local development moved to port 8001 due to another process occupying port 8000.
- adb reverse configured for tcp:8001.


## Development Environment Note

During Phase 6A debugging, port 8000 was occupied by another local process.
Development backend was validated on port 8001 using:

uvicorn app.main:app --reload --port 8001

Flutter:
AppConstants.baseUrl = http://127.0.0.1:8001

ADB:
adb reverse tcp:8001 tcp:8001


## Phase 6B Complete

Implemented AI Workflow Automation:

- Convert AI Action Items into Tasks
- Save AI Email Drafts as Meeting Notes
- Customer Insights feature
- Customer-specific context gathering
- Extended AI service architecture

Notes:
- Customer Insights currently uses MockLLMClient in development mode.
- Production OpenAIClient supports dynamic customer-specific analysis.
- No database migrations required.


# Airtel Employee App – Project Context Update (Post Phase 7)

## Project Overview

Building an internal Airtel B2B Employee CRM application using:

* Flutter (Frontend)
* FastAPI (Backend)
* PostgreSQL (Database)
* SQLAlchemy
* Riverpod
* JWT Authentication
* OpenAI-ready AI Copilot architecture

Target organizational hierarchy:

Circle Business Head (CBH)
→ Zonal Sales Manager (ZSM)
→ Account Manager (AM)

The application is intended for Airtel campus-level B2B sales operations.

---

## Completed Phases

### Core CRM

Implemented:

* Authentication & JWT login
* Customers module
* Meetings module
* Meeting Notes
* Tasks module
* Dashboard metrics

### AI Copilot

Implemented:

* Meeting Summary generation
* Action Item extraction
* Follow-up Email drafting

Architecture supports:

* MockLLMClient (current testing)
* OpenAIClient (production-ready)

### AI Workflow Automation (Phase 6B)

Implemented:

#### Action Items → Tasks

Users can:

* Extract action items from meeting notes
* Select desired items
* Create Tasks directly from AI output

#### Email Draft → Meeting Note

Users can:

* Generate follow-up email drafts
* Save generated content directly as meeting notes

#### Customer Insights

Implemented:

* AI Insights button on Customer Detail screen
* Backend context aggregation
* OpenAI-ready insight generation

Current limitation:
MockLLMClient returns static insights. Dynamic insights will automatically work once OpenAIClient is enabled.

---

## RBAC & Airtel Hierarchy (Phase 7)

### Database Changes

Added:

users.manager_id
customers.owner_id

Role hierarchy:

* account_manager
* zonal_sales_manager
* circle_business_head
* admin

### Backend RBAC

Implemented:

* Role-based authorization
* Data scoping
* Team visibility
* Manager hierarchy resolution
* User management APIs

Admin capabilities:

* Assign role
* Assign manager
* Activate/deactivate users
* Reset passwords

### Frontend RBAC

Implemented:

#### Admin Panel

* User listing
* Single-role assignment
* Manager assignment
* Active status toggle
* Password reset

#### Team Dashboard

Visible only to:

* Zonal Sales Managers

Hidden for:

* Admin
* CBH
* AM

#### Team Visibility

Implemented:

* Owner badges
* Team filtering
* Record ownership display

### Role Rules

Single-role enforcement implemented.

A user can only have ONE role:

* account_manager
* zonal_sales_manager
* circle_business_head
* admin

No multi-role assignments allowed.

---

## Current Test Accounts

Admin account:

Email:
[admin@airtel.com](mailto:admin@airtel.com)

Password:
secure

Hierarchy test users:

CBH:
[pritam@test.com](mailto:pritam@test.com)

ZSM:
[manager@airtel.com](mailto:manager@airtel.com)

AM:
[test@airtel.com](mailto:test@airtel.com)

Additional AM:
[user1@example.com](mailto:user1@example.com)

Passwords may be reset through Admin Panel.

---

## Known Non-Blocking Improvements

Deferred intentionally:

* Additional dashboard polish
* Better analytics visualizations
* Enhanced AI prompts
* Audit logging
* Production-grade password recovery
* Notification system
* Advanced reporting

These are future enhancements and not blockers.

---

## Current Status

Phase 7 is functionally complete and tested.

The application now includes:

* CRM
* Meetings
* Notes
* Tasks
* AI Copilot
* AI Workflow Automation
* Airtel Sales Hierarchy
* RBAC
* Admin Panel
* Team Dashboard
* Team Filtering
* Password Reset

The next major development phase is:

### Phase 8 – Airtel Enterprise UI/UX Redesign

Focus areas:

* Modern Airtel-inspired design system
* Enterprise dashboard redesign
* Better navigation
* Improved cards/tables
* Data visualization
* Responsive layouts
* Professional production-ready appearance


PHASE 8A COMPLETE

Branding:
- Rebranded app from Airtel B2B Sales Assistant to Airtel Nexus.
- Added branded splash screen.

Navigation:
- Implemented StatefulShellRoute architecture.
- Bottom navigation contains:
  Home
  Customers
  Activities
  Knowledge
- Removed More tab.
- Added Airtel-style slide drawer.

Dashboard:
- Redesigned Home Dashboard with Airtel-inspired UI.
- Added Hero Card.
- Added quick actions.
- Added Upcoming Meetings section.
- Added Recent Customers section.
- Added analytics section.

Activities:
- Unified Tasks and Meetings under Activities tab.

Knowledge:
- Created placeholder foundation for future Airtel IQ.

Drawer:
- Profile
- Settings
- Notifications (placeholder)
- Airtel IQ (placeholder)
- Sales Playbooks (placeholder)
- Team Dashboard (RBAC)
- Admin Panel (RBAC)
- Logout

RBAC:
- Preserved existing Admin/ZSM/Account Manager visibility rules.

Next Phase:
PHASE 8B - Airtel IQ Knowledge Center
- About Airtel
- Airtel Product Catalog
- Sales Playbooks
- FAQ
- Objection Handling
- AI Sales Coach