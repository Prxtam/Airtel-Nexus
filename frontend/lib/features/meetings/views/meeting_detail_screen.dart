import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/features/meeting_notes/models/meeting_note.dart';
import 'package:frontend/features/meeting_notes/providers/meeting_note_provider.dart';
import 'package:frontend/features/meetings/models/meeting.dart';
import 'package:frontend/features/meetings/providers/meeting_provider.dart';
import 'package:gap/gap.dart';

class MeetingDetailScreen extends ConsumerWidget {
  final String meetingId;
  const MeetingDetailScreen({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingAsync = ref.watch(meetingDetailProvider(meetingId));

    return Scaffold(
      backgroundColor: AppConstants.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          meetingAsync.maybeWhen(
            data: (m) => m.title ?? 'Meeting',
            orElse: () => 'Meeting',
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: meetingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.read(meetingDetailProvider(meetingId).notifier).load(),
        ),
        data: (meeting) =>
            _MeetingDetailBody(meeting: meeting, meetingId: meetingId),
      ),
    );
  }
}

// ============================================================
// Body (StatefulWidget for inline edit state)
// ============================================================

class _MeetingDetailBody extends ConsumerStatefulWidget {
  final Meeting meeting;
  final String meetingId;
  const _MeetingDetailBody(
      {required this.meeting, required this.meetingId});

  @override
  ConsumerState<_MeetingDetailBody> createState() =>
      _MeetingDetailBodyState();
}

class _MeetingDetailBodyState extends ConsumerState<_MeetingDetailBody> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  DateTime? _editMeetingAt;
  bool _isSaving = false;
  bool _isDeleting = false;
  String? _editError;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.meeting.title ?? '');
    _editMeetingAt = widget.meeting.meetingAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final local = (_editMeetingAt ?? widget.meeting.meetingAt).toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: local,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(local),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppConstants.primaryColor),
        ),
        child: child!,
      ),
    );
    if (!mounted) return;
    setState(() {
      _editMeetingAt = DateTime(date.year, date.month, date.day,
          time?.hour ?? local.hour, time?.minute ?? local.minute);
    });
  }

  Future<void> _saveEdit() async {
    setState(() {
      _isSaving = true;
      _editError = null;
    });
    try {
      final title = _titleController.text.trim();
      await ref.read(meetingDetailProvider(widget.meetingId).notifier).update(
            title: title.isEmpty ? null : title,
            meetingAt: _editMeetingAt,
          );
      ref.invalidate(meetingListProvider);
      if (mounted) setState(() => _isEditing = false);
    } catch (e) {
      setState(() => _editError = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meeting'),
        content: const Text(
            'This will permanently delete the meeting and all its notes. This action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await ref
          .read(meetingListProvider.notifier)
          .deleteMeeting(widget.meetingId);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meeting = widget.meeting;
    final isUpcoming = meeting.meetingAt.isAfter(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Meeting Info Card
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: (isUpcoming ? Colors.green : Colors.grey)
                            .withValues(alpha: 0.12),
                        radius: 26,
                        child: Icon(
                          isUpcoming ? Icons.event : Icons.event_available,
                          color: isUpcoming ? Colors.green : Colors.grey,
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meeting.title ?? 'Untitled Meeting',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Gap(4),
                            Text(
                              _formatDateTime(meeting.meetingAt),
                              style: TextStyle(
                                color: isUpcoming
                                    ? Colors.green.shade700
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!_isEditing)
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          color: AppConstants.primaryColor,
                          onPressed: () => setState(() => _isEditing = true),
                        ),
                    ],
                  ),

                  if (_isEditing) ...[
                    const Gap(20),
                    const Divider(),
                    const Gap(12),
                    const Text('Edit Meeting',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const Gap(12),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title (optional)',
                        border: OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const Gap(12),
                    OutlinedButton.icon(
                      onPressed: _pickDateTime,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(_editMeetingAt == null
                          ? 'Select date and time'
                          : _formatDateTime(_editMeetingAt!)),
                      style: OutlinedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                      ),
                    ),
                    if (_editError != null) ...[
                      const Gap(8),
                      Text(_editError!,
                          style: const TextStyle(color: Colors.red)),
                    ],
                    const Gap(12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: _isSaving
                              ? null
                              : () {
                                  _titleController.text =
                                      widget.meeting.title ?? '';
                                  _editMeetingAt = widget.meeting.meetingAt;
                                  setState(() {
                                    _isEditing = false;
                                    _editError = null;
                                  });
                                },
                          child: const Text('Cancel'),
                        ),
                        const Gap(8),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Intelligence Hub CTA
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppConstants.primaryColor, Colors.red.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.push('/meetings/${widget.meetingId}/intelligence'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.psychology, color: Colors.white, size: 28),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Generate Meeting Intelligence',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              'Exec summary, action items, and risks.',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Notes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Meeting Notes',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: () => context
                    .push('/meetings/${widget.meetingId}/notes/create'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Note'),
                style: TextButton.styleFrom(
                    foregroundColor: AppConstants.primaryColor),
              ),
            ],
          ),
          const Gap(8),

          _NotesSection(meetingId: widget.meetingId),

          const Gap(32),

          // Delete Meeting
          OutlinedButton.icon(
            onPressed: _isDeleting ? null : _confirmDelete,
            icon: _isDeleting
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        color: Colors.red, strokeWidth: 2),
                  )
                : const Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              _isDeleting ? 'Deleting...' : 'Delete Meeting',
              style: const TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}  ${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }
}

// ============================================================
// Embedded Notes Section
// ============================================================

class _NotesSection extends ConsumerWidget {
  final String meetingId;
  const _NotesSection({required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(meetingNoteListProvider(meetingId));

    return notesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorWidget(
        message: e.toString(),
        onRetry: () =>
            ref.read(meetingNoteListProvider(meetingId).notifier).refresh(),
      ),
      data: (notes) {
        if (notes.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.note_outlined, color: Colors.grey),
                Gap(12),
                Text('No notes yet. Tap Add Note to begin.',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          children: notes
              .map((note) => _NoteTile(note: note, meetingId: meetingId))
              .toList(),
        );
      },
    );
  }
}

class _NoteTile extends StatelessWidget {
  final MeetingNote note;
  final String meetingId;
  const _NoteTile({required this.note, required this.meetingId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.note, color: Colors.purple),
        title: Text(note.noteText, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          _formatDate(note.createdAt),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context
            .push('/meetings/$meetingId/notes/${note.id}'),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year}';
  }
}
