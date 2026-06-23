import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String? fullName;
  @HiveField(3)
  final List<String> roles;
  @HiveField(4)
  final String? employeeId;
  @HiveField(5)
  final String? circle;

  User({
    required this.id,
    required this.email,
    this.fullName,
    this.roles = const [],
    this.employeeId,
    this.circle,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  bool get isAdmin => roles.contains('admin');
  bool get isCBH => roles.contains('circle_business_head');
  bool get isZSM => roles.contains('zonal_sales_manager');
  bool get isAM => roles.contains('account_manager');
  
  bool get hasManagerAccess => isAdmin || isCBH || isZSM;
  
  User copyWith({
    String? id,
    String? email,
    String? fullName,
    List<String>? roles,
    String? employeeId,
    String? circle,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      roles: roles ?? this.roles,
      employeeId: employeeId ?? this.employeeId,
      circle: circle ?? this.circle,
    );
  }
}
