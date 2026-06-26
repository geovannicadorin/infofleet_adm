import 'package:get/get.dart';

import '../bindings/asset_form_binding.dart';
import '../bindings/splash_binding.dart';
import 'app_routes.dart';
import 'auth_guard.dart';

// Imports das Views e Bindings...
import '../../features/splash/presentation/views/splash_page.dart';
import '../../features/auth/presentation/views/login_page.dart';
import '../bindings/auth_binding.dart';
import '../../features/home/presentation/views/home_page.dart';
import '../bindings/home_binding.dart';

// --- IMPORTS DE ATIVOS ---
import '../../features/assets/presentation/views/asset_form_page.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    // A Home é o shell da aplicação. A Listagem de Ativos é renderizada
    // dentro dela (Navigator aninhado), então NÃO há rota standalone /assets.
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
      middlewares: [AuthGuard()],
    ),

    // O formulário de Ativo abre em tela cheia (sobre o shell), por isso
    // permanece como rota de nível raiz.
    GetPage(
      name: Routes.ASSETS_FORM,
      page: () => const AssetFormPage(),
      binding: AssetFormBinding(),
      middlewares: [AuthGuard()],
    ),
  ];
}