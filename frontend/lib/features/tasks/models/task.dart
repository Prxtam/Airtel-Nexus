import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 4)
enum TaskStatus { 
  @HiveField(0) pending, 
  @HiveField(1) completed 
}

@HiveType(typeId: 5)
enum TaskPriority { 
  @HiveField(0) low, 
  @HiveField(1) medium, 
  @HiveField(2) high 
}

@HiveType(typeId: 3)
@JsonSerializable(fieldRename: FieldRename.snake)
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final TaskPriority priority;
  @HiveField(5)
  final TaskStatus status;
  @HiveField(6)
  final DateTime? dueAt;
  @HiveField(7)
  final DateTime? completedAt;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.priority,
    required this.status,
    this.dueAt,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
