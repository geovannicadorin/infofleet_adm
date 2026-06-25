import '../entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<AuthEntity> login(String email, String password);
}