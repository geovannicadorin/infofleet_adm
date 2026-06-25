import 'package:equatable/equatable.dart';

/// Entidade que representa os dados do utilizador logado.
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final String profile;
  final String? avatar;

  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.profile,
    this.avatar,
  });

  @override
  List<Object?> get props => [id, email, fullName, profile, avatar];
}

/// Entidade que encapsula a resposta completa do Login.
class AuthEntity extends Equatable {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  const AuthEntity({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [user, accessToken, refreshToken];
}