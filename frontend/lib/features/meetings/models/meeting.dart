import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'meeting.g.dart';

@HiveType(typeId: 7)
enum MeetingStatus {
  @HiveField(0)
  scheduled,
  @HiveField(1)
  awaitingConfirmation,
  @HiveField(2)
  conducted,
}

@HiveType(typeId: 2)
@JsonSerializable(fieldRename: FieldRename.snake)
class Meeting {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String customerId;
  @HiveField(2)
  final String createdByUserId;
  @HiveField(3)
  final String? title;
  @HiveField(4)
  final DateTime meetingAt;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7, defaultValue: MeetingStatus.scheduled)
  final MeetingStatus status;

  Meeting({
    required this.id,
    required this.customerId,
    required this.createdByUserId,
    this.title,
    required this.meetingAt,
    required this.createdAt,
    required this.updatedAt,
    this.status = MeetingStatus.scheduled,
  });

  factory Meeting.fromJson(Map<String, dynamic> json) =>
      _$MeetingFromJson(json);
  Map<String, dynamic> toJson() => _$MeetingToJson(this);
}
