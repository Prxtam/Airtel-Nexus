import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/core/services/meeting_notification_service.dart';
import 'package:frontend/core/storage/hive_service.dart';
import 'package:frontend/features/meetings/services/notification_sync_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service
  final notificationService = MeetingNotificationService();
  await notificationService.initialize();

  // Initialize Hive storage
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Request permissions on startup
    MeetingNotificationService().requestPermissions();

    // Start observing meetings for notifications at the root level
    ref.watch(notificationSyncProvider);

    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Airtel Nexus',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          primary: AppConstants.primaryColor,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
