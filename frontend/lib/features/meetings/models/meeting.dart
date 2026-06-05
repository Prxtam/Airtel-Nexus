import 'package:json_annotation/json_annotation.dart';

part 'meeting.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Meeting {
  final String id;
  final String customerId;
  final String createdByUserId;
  final String? title;
  final DateTime meetingAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meeting({
    required this.id,
    required this.customerId,
    required this.createdByUserId,
    this.title,
    required this.meetingAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
