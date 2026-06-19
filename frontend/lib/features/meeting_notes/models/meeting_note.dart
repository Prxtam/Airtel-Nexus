import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'meeting_note.g.dart';

@HiveType(typeId: 6)
@JsonSerializable(fieldRename: FieldRename.snake)
class MeetingNote {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String meetingId;
  @HiveField(2)
  final String authorUserId;
  @HiveField(3)
  final String noteText;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
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
