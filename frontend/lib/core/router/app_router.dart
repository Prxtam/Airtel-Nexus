import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/auth/views/login_screen.dart';
import 'package:frontend/features/dashboard/views/dashboard_screen.dart';
import 'package:frontend/features/dashboard/views/admin_dashboard_screen.dart';
import 'package:frontend/features/dashboard/views/team_dashboard_screen.dart';
import 'package:frontend/features/customers/views/customer_list_screen.dart';
import 'package:frontend/features/customers/views/customer_create_screen.dart';
import 'package:frontend/features/customers/views/customer_detail_screen.dart';
import 'package:frontend/features/tasks/views/task_list_screen.dart';
import 'package:frontend/features/tasks/views/task_create_screen.dart';
import 'package:frontend/features/tasks/views/task_detail_screen.dart';
import 'package:frontend/features/meetings/views/meeting_list_screen.dart';
import 'package:frontend/features/meetings/views/meeting_create_screen.dart';
import 'package:frontend/features/meetings/views/meeting_detail_screen.dart';
import 'package:frontend/features/meeting_notes/views/note_create_screen.dart';
import 'package:frontend/features/meeting_notes/views/note_detail_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.uri.toString() == '/login';

      if (authState.status == AuthStatus.initial) {
        return null;
      }
      if (!isAuth && !isLoggingIn) {
        return '/login';
      }
      if (isAuth && isLoggingIn) {
        return '/home';
      }
      if (isAuth && state.uri.toString() == '/') {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardScreen(),
      ),

      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/team',
        builder: (context, state) => const TeamDashboardScreen(),
      ),

      // ── Customers ──────────────────────────────────────────
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: '/customers/create',
        builder: (context, state) => const CustomerCreateScreen(),
      ),
      GoRoute(
        path: '/customers/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomerDetailScreen(customerId: id);
        },
      ),

      // ── Tasks ───────────────────────────────────────────────
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/tasks/create',
        builder: (context, state) => const TaskCreateScreen(),
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),

      // ── Meetings ────────────────────────────────────────────
      GoRoute(
        path: '/meetings',
        builder: (context, state) => const MeetingListScreen(),
      ),
      GoRoute(
        path: '/meetings/create',
        builder: (context, state) => const MeetingCreateScreen(),
      ),
      GoRoute(
        path: '/meetings/:meetingId',
        builder: (context, state) {
          final meetingId = state.pathParameters['meetingId']!;
          return MeetingDetailScreen(meetingId: meetingId);
        },
      ),

      // ── Meeting Notes (scoped under meetings) ──────────────
      GoRoute(
        path: '/meetings/:meetingId/notes/create',
        builder: (context, state) {
          final meetingId = state.pathParameters['meetingId']!;
          return NoteCreateScreen(meetingId: meetingId);
        },
      ),
      GoRoute(
        path: '/meetings/:meetingId/notes/:noteId',
        builder: (context, state) {
          final meetingId = state.pathParameters['meetingId']!;
          final noteId = state.pathParameters['noteId']!;
          return NoteDetailScreen(meetingId: meetingId, noteId: noteId);
        },
      ),
    ],
  );
});
