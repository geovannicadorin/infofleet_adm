import 'package:get/get.dart';

import 'app_routes.dart';
import 'auth_guard.dart'; // Importamos o Guard

// Imports das Views e Bindings...
import '../../features/auth/presentation/views/login_page.dart';
import '../bindings/auth_binding.dart';
import '../../features/home/presentation/views/home_page.dart';
import '../bindings/home_binding.dart';
import '../../features/assets/presentation/views/asset_form_page.dart';

class AppPages {
  AppPages._();

  // A Rota Inicial oficial da Aplicação
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      // Rota de LOGIN é pública. NÃO colocamos o AuthGuard aqui.
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      // APLICAÇÃO DO MIDDLEWARE: Ninguém acede ao Home sem passar por aqui
      middlewares: [AuthGuard()],
    ),
    GetPage(
      name: Routes.ASSETS_FORM,
      page: () => const AssetFormPage(),
      // Protegemos também os formulários internos
      middlewares: [AuthGuard()],
    ),
  ];
}