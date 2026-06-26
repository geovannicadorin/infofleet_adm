import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../dashboard/domain/models/menu_item_model.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  /// ID do Navigator interno (aninhado) usado pelo GetX para navegar
  /// apenas na área de conteúdo, mantendo a Sidebar fixa.
  static const int nestedNavigationId = 1;

  /// Largura a partir da qual a Sidebar fica fixa (desktop). Abaixo disso,
  /// vira um Drawer (mobile). Centralizado aqui para uso em toda a UI.
  static const double desktopBreakpoint = 800;

  /// Chave do Scaffold principal. Permite fechar o Drawer (no mobile)
  /// de forma segura, sem dar `pop` na tela quando estamos no desktop.
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Rota atualmente selecionada no menu lateral.
  /// Inicia em Ativos, que é a tela principal da aplicação.
  final RxString currentRoute = Routes.ASSETS.obs;

  /// Lista oficial de módulos preparados para expansão.
  final List<MenuItemModel> menuItems = [
    MenuItemModel(title: 'Dashboard', icon: Icons.dashboard_outlined, route: Routes.DASHBOARD),
    MenuItemModel(title: 'Ativos', icon: Icons.directions_car_outlined, route: Routes.ASSETS),
    MenuItemModel(title: 'Dispositivos', icon: Icons.router_outlined, route: Routes.DEVICES),
    MenuItemModel(title: 'Instalações', icon: Icons.build_circle_outlined, route: Routes.INSTALLATIONS),
    MenuItemModel(title: 'Configurações', icon: Icons.settings_outlined, route: Routes.SETTINGS),
  ];

  /// Título exibido na AppBar (mobile), derivado da rota ativa.
  String get currentTitle => menuItems
          .firstWhereOrNull((item) => item.route == currentRoute.value)
          ?.title ??
      'Infofleet ADM';

  /// Navega para uma nova seção DENTRO da área de conteúdo (Navigator aninhado),
  /// preservando a Sidebar sempre visível.
  void navigateTo(String route) {
    // Fecha o Drawer no mobile (no desktop é um no-op seguro).
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      scaffoldKey.currentState?.closeDrawer();
    }

    // Evita re-navegar para a mesma rota (apenas fecha o menu).
    if (currentRoute.value == route) return;

    currentRoute.value = route;

    // Navegação correta do GetX no Navigator aninhado, via id.
    Get.toNamed(route, id: nestedNavigationId);
  }

  /// Abre o menu lateral (Drawer) no mobile.
  void openDrawer() => scaffoldKey.currentState?.openDrawer();

  /// Executa o logout chamando o nosso serviço centralizado.
  void logout() => _authService.forceLogout();
}
