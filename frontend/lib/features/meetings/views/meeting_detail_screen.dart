import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/constants/app_constants.dart';
import 'package:frontend/core/widgets/app_error_widget.dart';
import 'package:frontend/core/utils/date_formatter.dart';
import 'package:frontend/features/customers/providers/customer_provider.dart';
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Delete Meeting', style: TextStyle(color: Colors.black)),
        content: const Text(
            'This will permanently delete the meeting and all its notes. This action cannot be undone.',
            style: TextStyle(color: Colors.grey)),
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
            color: Colors.white,
            surfaceTintColor: Colors.transparent,
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
                              AppDateFormatter.format(meeting.meetingAt),
                              style: TextStyle(
                                color: isUpcoming
                                    ? Colors.green.shade700
                                    : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Gap(8),
                            // Metadata Row
                            Consumer(
                              builder: (context, ref, child) {
                                final customerAsync = ref.watch(customerDetailProvider(meeting.customerId));
                                final customerName = customerAsync.valueOrNull?.name ?? 'Loading...';
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer: $customerName', style: const TextStyle(color: Colors.black87, fontSize: 13)),
                                    const Gap(2),
                                    Text('Status: ${isUpcoming ? "Scheduled" : "Completed"}', style: const TextStyle(color: Colors.black87, fontSize: 13)),
                                  ],
                                );
                              },
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
                          : AppDateFormatter.format(_editMeetingAt!)),
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



          const Gap(24),

          // Notes Section Header
          Consumer(builder: (context, ref, child) {
            final notesAsync = ref.watch(meetingNoteListProvider(widget.meetingId));
            final hasNotes = notesAsync.maybeWhen(data: (list) => list.isNotEmpty, orElse: () => false);
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Meeting Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (hasNotes)
                  TextButton.icon(
                    onPressed: () => context.push('/meetings/${widget.meetingId}/notes/create'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Note'),
                    style: TextButton.styleFrom(foregroundColor: AppConstants.primaryColor),
                  ),
              ],
            );
          }),
          
          const Gap(12),

          _NotesSection(meetingId: widget.meetingId),

          const Gap(32),

          // Delete Button (Standalone)
          Align(
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              onPressed: _isDeleting ? null : _confirmDelete,
              icon: _isDeleting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red, size: 18),
              label: Text(
                _isDeleting ? 'Deleting...' : 'Delete Meeting',
                style: const TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red, width: 0.5),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          const Gap(32),
        ],
      ),
    );
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('📝 No notes added yet',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 14)),
                const Gap(4),
                const Text('Add notes after the meeting to keep track of discussions and action items.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.4)),
                const Gap(12),
                OutlinedButton(
                  onPressed: () => context.push('/meetings/$meetingId/notes/create'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppConstants.primaryColor,
                    side: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Add Note', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
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
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: const Icon(Icons.note, color: Colors.purple),
        title: Text(note.noteText, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          AppDateFormatter.format(note.createdAt),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => context
            .push('/meetings/$meetingId/notes/${note.id}'),
      ),
    );
  }
}
