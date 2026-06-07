import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/meetings/views/meeting_list_screen.dart';
import 'package:frontend/features/tasks/views/task_list_screen.dart';
import 'package:frontend/features/users/views/team_filter_dropdown.dart';
import 'package:frontend/features/tasks/providers/task_filter_provider.dart';
import 'package:frontend/features/meetings/providers/meeting_filter_provider.dart';

class ActivitiesScreen extends ConsumerStatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  ConsumerState<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends ConsumerState<ActivitiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Activities'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Meetings'),
            Tab(text: 'Tasks'),
          ],
        ),
        actions: [
          // Render the appropriate filter based on the active tab
          if (_tabController.index == 0)
            TeamFilterDropdown(
              currentValue: ref.watch(meetingTeamFilterProvider),
              onChanged: (val) => ref.read(meetingTeamFilterProvider.notifier).state = val,
            )
          else
            TeamFilterDropdown(
              currentValue: ref.watch(taskTeamFilterProvider),
              onChanged: (val) => ref.read(taskTeamFilterProvider.notifier).state = val,
            ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MeetingListScreen(hideAppBar: true),
          TaskListScreen(hideAppBar: true),
        ],
      ),
    );
  }
}
