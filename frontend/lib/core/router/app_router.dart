import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/views/app_shell.dart';
import 'package:frontend/core/views/splash_screen.dart';
import 'package:frontend/features/auth/providers/auth_provider.dart';
import 'package:frontend/features/auth/views/login_screen.dart';
import 'package:frontend/features/airtel_iq/views/airtel_iq_dashboard_screen.dart';
import 'package:frontend/features/airtel_iq/views/products/products_list_screen.dart';
import 'package:frontend/features/airtel_iq/views/products/product_detail_screen.dart';
import 'package:frontend/features/airtel_iq/views/faq/faq_screen.dart';
import 'package:frontend/features/airtel_iq/views/playbooks/playbooks_list_screen.dart';
import 'package:frontend/features/airtel_iq/views/playbooks/playbook_detail_screen.dart';
import 'package:frontend/features/airtel_iq/views/objections/objection_handling_screen.dart';
import 'package:frontend/features/airtel_iq/views/ai_coach/ai_coach_dashboard_screen.dart';
import 'package:frontend/features/airtel_iq/views/ai_coach/meeting_prep_screen.dart';
import 'package:frontend/features/airtel_iq/views/ai_coach/opportunity_insights_screen.dart';
import 'package:frontend/features/airtel_iq/views/ai_coach/ask_airtel_iq_screen.dart';
import 'package:frontend/features/airtel_iq/views/knowledge_explorer/knowledge_explorer_screen.dart';
import 'package:frontend/features/airtel_iq/views/about_airtel/about_airtel_screen.dart';

import 'package:frontend/features/dashboard/views/dashboard_screen.dart';
import 'package:frontend/features/customers/views/customer_list_screen.dart';
import 'package:frontend/features/customers/views/customer_create_screen.dart';
import 'package:frontend/features/customers/views/customer_detail_screen.dart';
import 'package:frontend/features/tasks/views/task_create_screen.dart';
import 'package:frontend/features/tasks/views/task_detail_screen.dart';
import 'package:frontend/features/meetings/views/meeting_create_screen.dart';
import 'package:frontend/features/meetings/views/meeting_detail_screen.dart';
import 'package:frontend/features/meeting_notes/views/note_create_screen.dart';
import 'package:frontend/features/meeting_notes/views/note_detail_screen.dart';
import 'package:frontend/features/activities/views/activities_screen.dart';
import 'package:frontend/features/knowledge/views/knowledge_screen.dart';
import 'package:frontend/features/profile/views/profile_screen.dart';

// Standalone lists for quick access if needed, but mainly embedded in activities
import 'package:frontend/features/tasks/views/task_list_screen.dart';
import 'package:frontend/features/meetings/views/meeting_list_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _customersNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'customers');
final _activitiesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'activities');
final _knowledgeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'knowledge');
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.uri.toString() == '/login';

      if (authState.status == AuthStatus.initial) {
        return null;
      }
      if (!isAuth && !isLoggingIn && state.uri.toString() != '/') {
        return '/login';
      }
      if (isAuth && isLoggingIn) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // ── App Shell Routes (Bottom Navigation) ──────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Branch 1: Customers
          StatefulShellBranch(
            navigatorKey: _customersNavigatorKey,
            routes: [
              GoRoute(
                path: '/customers',
                builder: (context, state) => const CustomerListScreen(),
              ),
            ],
          ),
          // Branch 2: Activities
          StatefulShellBranch(
            navigatorKey: _activitiesNavigatorKey,
            routes: [
              GoRoute(
                path: '/activities',
                builder: (context, state) => const ActivitiesScreen(),
              ),
            ],
          ),
          // Branch 3: Knowledge
          StatefulShellBranch(
            navigatorKey: _knowledgeNavigatorKey,
            routes: [
              GoRoute(
                path: '/knowledge',
                builder: (context, state) => const KnowledgeScreen(),
              ),
            ],
          ),
        ],
      ),

      // Airtel Assist Routes (Outside Shell for full-screen focus)
      GoRoute(
        path: '/airtel-iq',
        builder: (context, state) => const AirtelIqDashboardScreen(),
        routes: [
          GoRoute(
            path: 'products',
            builder: (context, state) => const ProductsListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => ProductDetailScreen(
                  productId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'knowledge-hub',
            builder: (context, state) => const KnowledgeExplorerScreen(),
          ),
          GoRoute(
            path: 'about',
            builder: (context, state) => const AboutAirtelScreen(),
          ),
          GoRoute(
            path: 'faq',
            builder: (context, state) => const FaqScreen(),
          ),
          GoRoute(
            path: 'playbooks',
            builder: (context, state) => const PlaybooksListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PlaybookDetailScreen(
                  playbookId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'objections',
            builder: (context, state) => const ObjectionHandlingScreen(),
          ),
          GoRoute(
            path: 'ai-coach',
            builder: (context, state) => const AiCoachDashboardScreen(),
            routes: [
              GoRoute(
                path: 'meeting-prep',
                builder: (context, state) => const MeetingPrepScreen(),
              ),
              GoRoute(
                path: 'insights',
                builder: (context, state) => const OpportunityInsightsScreen(),
              ),

              GoRoute(
                path: 'ask',
                builder: (context, state) => const AskAirtelIqScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Full Screen Routes (Outside Shell) ───────────────

      // Dashboards
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Customers
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/customers/create',
        builder: (context, state) => const CustomerCreateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/customers/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomerDetailScreen(customerId: id);
        },
      ),

      // Tasks
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/tasks/create',
        builder: (context, state) => const TaskCreateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/tasks/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TaskDetailScreen(taskId: id);
        },
      ),

      // Meetings
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/meetings',
        builder: (context, state) => const MeetingListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/meetings/create',
        builder: (context, state) => const MeetingCreateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/meetings/:meetingId',
        builder: (context, state) {
          final meetingId = state.pathParameters['meetingId']!;
          return MeetingDetailScreen(meetingId: meetingId);
        },
      ),

      // Meeting Notes
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/meetings/:meetingId/notes/create',
        builder: (context, state) {
          final meetingId = state.pathParameters['meetingId']!;
          return NoteCreateScreen(meetingId: meetingId);
        },
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
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
