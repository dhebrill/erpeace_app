import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_role.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A user profile stored in the `profiles` table.
///
/// The JSON keys are the snake_case column names of the database.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @Default('') String fullName,
    String? email,
    @Default(UserRole.sales) UserRole role,
    @Default(false) bool isActive,
    DateTime? createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
