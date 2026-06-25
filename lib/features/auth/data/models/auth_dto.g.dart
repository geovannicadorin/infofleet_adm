// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTO _$UserDTOFromJson(Map<String, dynamic> json) => UserDTO(
  id: json['id'] as String,
  email: json['email'] as String,
  avatar: json['avatar'] as String?,
  fullName: json['fullName'] as String,
  userName: json['userName'] as String,
  role: json['role'] as String,
  profile: json['profile'] as String,
  plan: json['plan'] as String,
  language: json['language'] as String,
  timezone: (json['timezone'] as num).toInt(),
);

Map<String, dynamic> _$UserDTOToJson(UserDTO instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'avatar': instance.avatar,
  'fullName': instance.fullName,
  'userName': instance.userName,
  'role': instance.role,
  'profile': instance.profile,
  'plan': instance.plan,
  'language': instance.language,
  'timezone': instance.timezone,
};

AuthResponseDTO _$AuthResponseDTOFromJson(Map<String, dynamic> json) =>
    AuthResponseDTO(
      userData: UserDTO.fromJson(json['userData'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$AuthResponseDTOToJson(AuthResponseDTO instance) =>
    <String, dynamic>{
      'userData': instance.userData,
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
