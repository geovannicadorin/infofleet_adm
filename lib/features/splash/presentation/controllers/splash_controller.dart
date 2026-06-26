import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../app/routes/app_routes.dart';

/// Controla o tempo mínimo de exibição da splash e decide o destino
/// inicial da aplicação (Home se autenticado, caso contrário Login).
class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  /// Tempo mínimo em tela para a animação da marca respirar.
  static const Duration _minDisplay = Duration(milliseconds: 2600);

  @override
  void onReady() {
    super.onReady();
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await Future.delayed(_minDisplay);

    final destination =
        _authService.isLoggedIn.value ? Routes.HOME : Routes.LOGIN;

    Get.offAllNamed(destination);
  }
}
