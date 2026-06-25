import 'package:dio/dio.dart';
import '../interceptors/auth_interceptor.dart';

/// Classe responsável por configurar e fornecer a instância do Dio para todo o app.
class ApiClient {
  late final Dio _dio;

  // A tua Base URL fornecida no escopo do projeto
  static const String baseUrl = 'https://infofleet.onboard.ind.br';

  ApiClient() {
    // Configurações base (BaseOptions)
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15), // Tempo máximo para conectar
      receiveTimeout: const Duration(seconds: 15), // Tempo máximo para receber dados
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Inicializa o Dio com as opções
    _dio = Dio(options);

    // Adiciona o nosso Interceptador de Segurança
    _dio.interceptors.add(AuthInterceptor());
  }

  /// Expõe a instância do Dio para ser usada nos Repositories (Camada de Dados)
  Dio get dio => _dio;
}