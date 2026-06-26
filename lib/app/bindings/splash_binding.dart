import 'package:get/get.dart';

import '../../features/splash/presentation/controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put (e não lazyPut): a SplashPage não é um GetView e nunca acessa o
    // controller, então ele precisa ser criado imediatamente para que o
    // onReady dispare a navegação.
    Get.put(SplashController());
  }
}
