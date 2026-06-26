import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/bindings/asset_list_binding.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../assets/presentation/views/asset_list_page.dart';
import '../controllers/home_controller.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/sidebar_menu_button.dart';

/// Shell principal da aplicação: Sidebar fixa (desktop) ou Drawer (mobile)
/// + uma área de conteúdo que troca de seção via Navigator aninhado do GetX.
class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const double _sidebarWidth = 280;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop =
            constraints.maxWidth >= HomeController.desktopBreakpoint;
        final theme = Theme.of(context);

        return Scaffold(
          key: controller.scaffoldKey,
          // Sem AppBar no shell: cada seção tem a sua própria (com o botão
          // de menu no mobile), evitando AppBars duplicadas.
          drawer: isDesktop ? null : const AppSidebar(),
          body: Row(
            children: [
              if (isDesktop) ...[
                const SizedBox(width: _sidebarWidth, child: AppSidebar()),
                VerticalDivider(
                  width: 1,
                  color: theme.colorScheme.secondary.withOpacity(0.2),
                ),
              ],
              Expanded(child: _buildContentNavigator()),
            ],
          ),
        );
      },
    );
  }

  /// Navigator aninhado: renderiza a seção ativa do menu mantendo a Sidebar.
  Widget _buildContentNavigator() {
    return Navigator(
      key: Get.nestedKey(HomeController.nestedNavigationId),
      initialRoute: Routes.ASSETS,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.ASSETS:
        // A Listagem de Ativos É a tela principal da Home (sem duplicação).
        return GetPageRoute(
          settings: settings,
          page: () => const AssetListPage(),
          binding: AssetListBinding(),
          transition: Transition.fadeIn,
        );
      default:
        return GetPageRoute(
          settings: settings,
          page: () => _PlaceholderSection(title: controller.currentTitle),
          transition: Transition.fadeIn,
        );
    }
  }
}

/// Seção provisória para módulos ainda não implementados (Dashboard, etc.).
class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: SidebarMenuButton.leadingFor(context),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.construction_outlined,
                size: 48, color: theme.colorScheme.secondary),
            const SizedBox(height: 12),
            Text('Módulo em desenvolvimento', style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
