import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Customer {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
