import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/services/auth_service.dart';
import '../repositories/i_auth_repository.dart';
import '../entities/auth_entity.dart';

class LoginUseCase {
  final IAuthRepository _repository;
  final AuthService _authService;

  LoginUseCase(this._repository, this._authService);

  /// Executa o login e valida a regra de negócio do SYSADMIN.
  Future<UserEntity> call(String email, String password) async {
    // 1. Chama a API via Repositório
    final authData = await _repository.login(email, password);

    // 2. REGRA CRÍTICA: Valida o perfil do utilizador
    if (authData.user.profile != 'SYSADMIN') {
      // Por garantia, força a limpeza de qualquer resquício
      await _authService.forceLogout(); 
      throw AuthException('Acesso negado. Apenas administradores do sistema (SYSADMIN) têm permissão.');
    }

    // 3. Se for SYSADMIN, guarda os tokens com segurança
    await _authService.secureStorage.write(key: 'access_token', value: authData.accessToken);
    await _authService.secureStorage.write(key: 'refresh_token', value: authData.refreshToken);
    
    // 4. Marca o utilizador como logado no serviço global
    _authService.isLoggedIn.value = true;
    
    return authData.user;
  }
}