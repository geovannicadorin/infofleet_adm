import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import 'app_routes.dart';

/// Middleware de Segurança que impede o acesso a rotas protegidas sem autenticação.
class AuthGuard extends GetMiddleware {
  
  // Define a prioridade (útil se tivermos vários middlewares na mesma rota)
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Busca o serviço de autenticação que está sempre vivo na memória
    final authService = Get.find<AuthService>();

    // Se o utilizador NÃO estiver autenticado, bloqueia a passagem
    if (!authService.isLoggedIn.value) {
      // Redireciona para a tela de Login
      return const RouteSettings(name: Routes.LOGIN);
    }

    // Se a função retornar null, significa que não há redirecionamento.
    // Ou seja, o utilizador tem permissão e a navegação continua normalmente!
    return null;
  }
}