import 'package:json_annotation/json_annotation.dart';

part 'meeting_note.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MeetingNote {
  final String id;
  final String meetingId;
  final String authorUserId;
  final String noteText;
  final DateTime createdAt;
  final DateTime updatedAt;

  MeetingNote({
    required this.id,
    required this.meetingId,
    required this.authorUserId,
    required this.noteText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MeetingNote.fromJson(Map<String, dynamic> json) =>
      _$MeetingNoteFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingNoteToJson(this);
}
