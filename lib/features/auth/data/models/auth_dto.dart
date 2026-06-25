import 'package:json_annotation/json_annotation.dart';

// Necessário para o build_runner gerar o código
part 'auth_dto.g.dart';

@JsonSerializable()
class UserDTO {
  final String id;
  final String email;
  final String? avatar;
  final String fullName;
  final String userName;
  final String role;
  final String profile;
  final String plan;
  final String language;
  final int timezone;

  UserDTO({
    required this.id,
    required this.email,
    this.avatar,
    required this.fullName,
    required this.userName,
    required this.role,
    required this.profile,
    required this.plan,
    required this.language,
    required this.timezone,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);
}

@JsonSerializable()
class AuthResponseDTO {
  final UserDTO userData;
  final String accessToken;
  final String refreshToken;

  AuthResponseDTO({
    required this.userData,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) => _$AuthResponseDTOFromJson(json);
}