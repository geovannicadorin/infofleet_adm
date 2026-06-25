import '../../domain/entities/auth_entity.dart';
import '../models/auth_dto.dart';

/// Transforma o DTO "sujo" da API numa Entidade "limpa" para o Domínio.
class AuthMapper {
  static AuthEntity toEntity(AuthResponseDTO dto) {
    return AuthEntity(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      user: UserEntity(
        id: dto.userData.id,
        email: dto.userData.email,
        fullName: dto.userData.fullName,
        profile: dto.userData.profile,
        avatar: dto.userData.avatar,
      ),
    );
  }
}