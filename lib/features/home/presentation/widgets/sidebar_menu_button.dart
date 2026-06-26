import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

/// Botão de menu (hambúrguer) para as seções renderizadas dentro do shell.
///
/// É exibido apenas no mobile (abaixo do breakpoint), abrindo o Drawer do
/// shell principal. No desktop retorna um widget vazio, pois a Sidebar já
/// fica fixa na lateral.
class SidebarMenuButton extends StatelessWidget {
  const SidebarMenuButton({super.key});

  /// Retorna o botão para uso direto em `AppBar.leading`, ou `null` no desktop
  /// (assim a AppBar não reserva espaço desnecessário).
  static Widget? leadingFor(BuildContext context) {
    final isDesktop =
        MediaQuery.sizeOf(context).width >= HomeController.desktopBreakpoint;
    return isDesktop ? null : const SidebarMenuButton();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Menu',
      onPressed: () {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().openDrawer();
        }
      },
    );
  }
}
