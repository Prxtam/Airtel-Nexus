import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(fieldRename: FieldRename.snake)
class Customer {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? ownerId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final DateTime updatedAt;

  Customer({
    required this.id,
    this.ownerId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
