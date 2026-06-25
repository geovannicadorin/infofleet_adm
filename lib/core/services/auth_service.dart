import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../../app/routes/app_routes.dart';

class AuthService extends GetxService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final GetStorage getStorage = GetStorage();
  final Logger logger = Logger();

  final RxBool isLoggedIn = false.obs;

  /// Método chamado na inicialização do main.dart para verificar sessões anteriores.
  Future<AuthService> init() async {
    logger.i('Verificando estado de autenticação...');
    final token = await secureStorage.read(key: 'access_token');
    
    if (token != null && token.isNotEmpty) {
      isLoggedIn.value = true;
      logger.i('Utilizador já autenticado com token existente.');
    } else {
      isLoggedIn.value = false;
    }
    
    return this;
  }

  Future<void> forceLogout() async {
    logger.w('Executando Logout Forçado...');
    try {
      await secureStorage.deleteAll();
      await getStorage.erase();
      isLoggedIn.value = false;
      Get.deleteAll(force: true);
      
      Get.offAllNamed(Routes.LOGIN);
      
      Get.snackbar('Sessão Encerrada', 'Por favor, faça login novamente.');
    } catch (e) {
      logger.e('Erro ao fazer logout: $e');
    }
  }
}