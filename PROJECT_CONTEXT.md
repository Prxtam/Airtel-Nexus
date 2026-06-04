# Airtel B2B Sales Assistant

## Project Overview

A mobile-first Airtel B2B Sales Assistant application designed to help sales representatives manage customers, tasks, meetings, and meeting notes from a single platform.

The application consists of:

* FastAPI backend
* PostgreSQL database
* Flutter mobile frontend
* JWT authentication
* Riverpod state management
* GoRouter navigation

The project is being developed incrementally with business functionality prioritized before UI redesigns.

---

# Current Development Status

## Backend Status

### Foundation

Completed and tested:

* FastAPI setup
* PostgreSQL integration
* SQLAlchemy ORM
* Alembic migrations
* Environment configuration
* Repository structure
* GitHub integration

### Authentication

Completed and tested:

* User registration
* User login
* JWT access tokens
* Password hashing (bcrypt)
* Protected routes
* Current user endpoint (`/auth/me`)

All authentication flows verified through Swagger.

---

## Backend Modules

### Customers Module

Completed and tested.

Endpoints:

* POST `/customers`
* GET `/customers`
* GET `/customers/{id}`
* PATCH `/customers/{id}`
* DELETE `/customers/{id}`

Features:

* Ownership validation
* CRUD operations
* Swagger tested
* Database persistence verified

Schema:

```json
{
  "id": "uuid",
  "name": "string",
  "created_at": "datetime",
  "updated_at": "datetime"
}
```

---

### Tasks Module

Completed and tested on backend.

Status:

* API implementation complete
* Swagger testing complete

Frontend not yet implemented.

---

### Meetings Module

Completed and tested on backend.

Status:

* API implementation complete
* Swagger testing complete

Frontend not yet implemented.

---

### Meeting Notes Module

Completed and tested on backend.

Status:

* API implementation complete
* Swagger testing complete

Frontend not yet implemented.

---

## Database Features

Verified:

* Foreign key relationships
* Ownership validation
* Cascade delete behavior
* Alembic migrations
* Data persistence

---

# Frontend Status

## Foundation

Completed:

* Flutter setup
* Riverpod
* Dio
* GoRouter
* Secure storage
* JWT persistence
* API integration

---

## Authentication Flow

Completed and tested on Android device.

Features:

* Login screen
* Token persistence
* Automatic session restoration
* Protected navigation
* Logout functionality

Behavior:

* User remains logged in after app restart when token is valid.
* App automatically routes authenticated users to dashboard.

---

## Dashboard

Completed.

Current dashboard serves as a temporary landing page.

Features:

* Welcome section
* Metrics cards
* Quick actions
* Airtel-themed styling
* Navigation entry points

Current quick actions:

* Add Customer
* View Customers
* Create Task (placeholder)
* Schedule Meeting (placeholder)

---

# Customers Frontend Module

Status: COMPLETE

Implemented and tested on physical Android device (Pixel 9).

---

## Customer List Screen

Route:

```text
/customers
```

Features:

* Customer list retrieval
* Pull-to-refresh
* Loading state
* Error state
* Empty state
* FAB for customer creation
* Customer detail navigation

Verified working.

---

## Customer Detail Screen

Route:

```text
/customers/:id
```

Features:

* Fetch by customer ID
* Independent detail provider
* Customer information display
* Inline editing
* Delete action
* Timestamp display

Verified working.

---

## Customer Creation

Route:

```text
/customers/create
```

Features:

* Form validation
* Backend integration
* Successful list refresh after creation
* Validation errors displayed inline

Verified working.

---

## Customer Editing

Features:

* Inline edit mode
* PATCH integration
* Automatic detail refresh
* Automatic list synchronization

Verified working.

---

## Customer Deletion

Features:

* Confirmation dialog
* DELETE integration
* Automatic navigation back
* Automatic list refresh

Verified working.

---

## Shared Components

Created:

### AppErrorWidget

Reusable error state widget.

Intended for:

* Customers
* Tasks
* Meetings
* Notes

### AppEmptyWidget

Reusable empty state widget.

Intended for:

* Customers
* Tasks
* Meetings
* Notes

---

# Flutter Architecture

Feature-first architecture.

Current structure:

```text
lib/
|
├── core/
│   ├── api/
│   ├── constants/
│   ├── router/
│   ├── storage/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── dashboard/
│   └── customers/
```

---

## State Management

Riverpod

Patterns currently used:

* Provider
* StateNotifierProvider
* StateNotifierProvider.family

Customer module includes:

* customerListProvider
* customerDetailProvider(id)

---

## API Layer

Dio-based networking.

Shared infrastructure:

* JWT interceptor
* Secure token storage
* Centralized API configuration

No duplicate API clients should be introduced.

---

# Important Product Decisions

## Mobile First

The application is optimized primarily for mobile devices.

Current testing device:

* Google Pixel 9

---

## Navigation Strategy

Current state:

Dashboard → Feature Screens

Intentionally postponed:

* Bottom navigation bar
* Home redesign
* Navigation restructuring

Reason:

Business functionality takes priority over UI polish.

---

## UI Strategy

Current UI is functional but temporary.

Planned future phase:

### Airtel UX Refresh

Includes:

* Dedicated Airtel Home Screen
* Bottom Navigation
* Improved spacing and typography
* Better business-focused dashboard
* Improved customer/task/meeting cards
* Stronger Airtel branding

This redesign should occur only after all business modules are complete.

---

# Current Milestone

Completed:

* Backend foundation
* Authentication
* Customers backend
* Tasks backend
* Meetings backend
* Meeting Notes backend
* Flutter foundation
* Authentication frontend
* Dashboard frontend
* Customers frontend

---

# Next Phase

## Tasks Frontend Module

Before implementation:

1. Inspect backend Tasks API.
2. Verify schemas.
3. Verify validation rules.
4. Verify relationships.
5. Produce implementation plan.
6. Review plan before coding.

Do not begin implementation before plan approval.

---

# Testing Status

## Backend

Swagger tested.

Verified:

* Authentication
* Customers
* Tasks
* Meetings
* Meeting Notes

---

## Frontend

Android device tested.

Verified:

* Login
* Session persistence
* Dashboard
* Customer list
* Customer creation
* Customer editing
* Customer deletion
* Pull-to-refresh
* Navigation

---

# Latest Completed Milestone

Frontend Customers Module completed and approved after manual testing on physical Android device.

Recommended commit:

feat(customers): implement customer management frontend module
