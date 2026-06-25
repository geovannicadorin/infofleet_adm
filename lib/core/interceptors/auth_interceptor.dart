import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart' as getx; // Alias para evitar conflitos de nome
import 'package:logger/logger.dart';
import '../services/auth_service.dart';

/// Interceptador que atua em todas as requisições e respostas HTTP.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger logger = Logger();

  /// Executado ANTES da requisição ir para a API.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Busca o token guardado de forma segura
    final accessToken = await secureStorage.read(key: 'access_token');

    // Se o token existir, injeta-o no cabeçalho (Header) de Autorização
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    logger.i('=> ENVIANDO REQUISIÇÃO: [${options.method}] ${options.uri}');
    
    // Continua a requisição
    super.onRequest(options, handler);
  }

  /// Executado quando a API devolve um ERRO.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e('<= ERRO NA REQUISIÇÃO: [${err.response?.statusCode}] ${err.requestOptions.uri}');

    // Verifica a tua REGRA CRÍTICA: Se for 401 (Unauthorized) ou 403 (Forbidden)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      logger.w('Token inválido ou expirado. Iniciando processo de logout.');
      
      // Procura o AuthService que está na memória e executa o logout
      final authService = getx.Get.find<AuthService>();
      await authService.forceLogout();
    }

    // Passa o erro para a frente para que a tela saiba que falhou (para remover o loading, por exemplo)
    super.onError(err, handler);
  }
}