import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/i_auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Regista o Repositório passando o Dio (que já estava no main.dart)
    Get.lazyPut<IAuthRepository>(() => AuthRepositoryImpl(Get.find<Dio>()));
    
    // 2. Regista o UseCase passando o Repositório e o AuthService
    Get.lazyPut(() => LoginUseCase(Get.find<IAuthRepository>(), Get.find<AuthService>()));
    
    // 3. Regista o Controller passando o UseCase
    Get.lazyPut(() => AuthController(Get.find<LoginUseCase>()));
  }
}