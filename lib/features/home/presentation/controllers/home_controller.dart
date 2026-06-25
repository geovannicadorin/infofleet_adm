import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/auth_service.dart';
import '../../../dashboard/domain/models/menu_item_model.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  // O ID do nosso Navigator interno (necessário para o GetX)
  static const int nestedNavigationId = 1;

  // Rota atual selecionada (Inicializa com Ativos, conforme a regra de negócio)
  final RxString currentRoute = '/assets'.obs;

  // Lista oficial de módulos preparados para expansão
  final List<MenuItemModel> menuItems = [
    MenuItemModel(title: 'Dashboard', icon: Icons.dashboard_outlined, route: '/dashboard'),
    MenuItemModel(title: 'Ativos', icon: Icons.directions_car_outlined, route: '/assets'),
    MenuItemModel(title: 'Dispositivos', icon: Icons.router_outlined, route: '/devices'),
    MenuItemModel(title: 'Instalações', icon: Icons.build_circle_outlined, route: '/installations'),
    MenuItemModel(title: 'Configurações', icon: Icons.settings_outlined, route: '/settings'),
  ];

  @override
  void onInit() {
    super.onInit();
    // Ao iniciar o Home, o comportamento padrão é garantir que estamos na rota de Ativos
    // Usamos um pequeno delay para garantir que o Navigator aninhado já foi construído na View.
    Future.delayed(const Duration(milliseconds: 100), () {
      navigateTo('/assets');
    });
  }

  /// Navega para uma nova rota DENTRO do layout principal
  void navigateTo(String route) {
    if (currentRoute.value == route) return; // Evita recarregar a mesma tela
    
    currentRoute.value = route;
    
    // O pulo do gato: Get.toNamed usando o id da navegação aninhada!
    Get.toNamed(route, id: nestedNavigationId);
    
    // Se estivermos num ecrã pequeno (mobile) e o Drawer estiver aberto, fecha-o.
    if (Scaffold.of(Get.context!).isDrawerOpen) {
      Get.back(); 
    }
  }

  /// Executa o logout chamando o nosso serviço centralizado
  void logout() {
    _authService.forceLogout();
  }
}