import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/features/ai/providers/ai_provider.dart';
import 'package:frontend/features/meeting_notes/providers/meeting_note_provider.dart';
import 'package:frontend/features/meeting_notes/repositories/meeting_note_repository.dart';
import 'package:frontend/features/tasks/providers/task_provider.dart';
import 'package:frontend/features/tasks/repositories/task_repository.dart';
import 'package:gap/gap.dart';

class MeetingCopilotSheet extends ConsumerStatefulWidget {
  final String meetingId;

  const MeetingCopilotSheet({super.key, required this.meetingId});

  static Future<void> show(BuildContext context, String meetingId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => MeetingCopilotSheet(meetingId: meetingId),
    );
  }

  @override
  ConsumerState<MeetingCopilotSheet> createState() => _MeetingCopilotSheetState();
}

class _MeetingCopilotSheetState extends ConsumerState<MeetingCopilotSheet> {
  final Set<int> _selectedActionIndices = {};
  bool _isCreatingTasks = false;
  bool _isSavingNote = false;

  Future<void> _createSelectedTasks(List<String> allItems) async {
    setState(() => _isCreatingTasks = true);
    try {
      final taskRepo = ref.read(taskRepositoryProvider);
      for (final index in _selectedActionIndices) {
        await taskRepo.createTask(
          title: allItems[index],
          description: 'Auto-generated from Meeting Actions',
          priority: 'medium',
        );
      }
      ref.invalidate(taskListProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tasks created successfully')));
        setState(() => _selectedActionIndices.clear());
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isCreatingTasks = false);
    }
  }

  Future<void> _saveAsNote(String text) async {
    setState(() => _isSavingNote = true);
    try {
      final noteRepo = ref.read(meetingNoteRepositoryProvider);
      await noteRepo.createNote(meetingId: widget.meetingId, noteText: text);
      ref.invalidate(meetingNoteListProvider(widget.meetingId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved as Meeting Note')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isSavingNote = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiCopilotProvider);
    final aiNotifier = ref.read(aiCopilotProvider.notifier);

    ref.listen<AICopilotState>(aiCopilotProvider, (previous, next) {
      if (previous?.actionItems == null && next.actionItems != null) {
        setState(() {
          _selectedActionIndices.clear();
          for (int i = 0; i < next.actionItems!.length; i++) {
            _selectedActionIndices.add(i);
          }
        });
      }
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.purple.shade700),
                      const Gap(8),
                      const Text(
                        'AI Copilot',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Gap(16),

              // Action Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ActionButton(
                      label: 'Summarize',
                      icon: Icons.summarize,
                      onPressed: () => aiNotifier.generateSummary(widget.meetingId),
                    ),
                    const Gap(12),
                    _ActionButton(
                      label: 'Extract Actions',
                      icon: Icons.checklist,
                      onPressed: () => aiNotifier.extractActions(widget.meetingId),
                    ),
                    const Gap(12),
                    _ActionButton(
                      label: 'Draft Email',
                      icon: Icons.email,
                      onPressed: () => aiNotifier.draftEmail(widget.meetingId),
                    ),
                  ],
                ),
              ),
              const Gap(24),

              // Content Area
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: _buildContent(aiState, context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(AICopilotState state, BuildContext context) {
    if (state.isLoading) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Gap(16),
          Text('AI is thinking...', style: TextStyle(color: Colors.grey)),
        ],
      );
    }

    if (state.error != null) {
      return Center(
        child: Text(
          state.error!,
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (state.actionItems != null) {
      if (state.actionItems!.isEmpty) {
         return const Center(child: Text('No action items found.'));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Select items to create tasks:', style: TextStyle(fontWeight: FontWeight.bold)),
          const Gap(12),
          Expanded(
            child: ListView.builder(
              itemCount: state.actionItems!.length,
              itemBuilder: (context, index) {
                final item = state.actionItems![index];
                final isSelected = _selectedActionIndices.contains(index);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedActionIndices.add(index);
                      } else {
                        _selectedActionIndices.remove(index);
                      }
                    });
                  },
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              },
            ),
          ),
          const Gap(16),
          ElevatedButton(
            onPressed: _isCreatingTasks || _selectedActionIndices.isEmpty
                ? null
                : () => _createSelectedTasks(state.actionItems!),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: _isCreatingTasks
                ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Create Selected Tasks'),
          ),
        ],
      );
    }

    if (state.resultText != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: _isSavingNote ? null : () => _saveAsNote(state.resultText!),
                icon: _isSavingNote 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save, size: 16),
                label: const Text('Save as Note'),
              ),
              const Gap(8),
              TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: state.resultText!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied to clipboard')),
                  );
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy'),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                state.resultText!,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Text(
        'Select an action above to generate AI insights from your meeting notes.',
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.purple.shade700,
        backgroundColor: Colors.purple.shade50,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.purple.shade100),
        ),
      ),
    );
  }
}
