import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/app_sidebar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos um LayoutBuilder para tornar o layout responsivo
    // Se for tablet/desktop, a Sidebar fica fixa. Se for telemóvel, vira um Drawer escondido.
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800; // Ponto de quebra (breakpoint)

        return Scaffold(
          // Se for telemóvel, usamos AppBar com botão de hambúrguer
          appBar: isDesktop
              ? null
              : AppBar(
                  title: Obx(() {
                    // Atualiza o título da AppBar dinamicamente com base na rota
                    final currentItem = controller.menuItems.firstWhereOrNull(
                      (item) => item.route == controller.currentRoute.value,
                    );
                    return Text(currentItem?.title ?? 'Infofleet ADM');
                  }),
                ),
          
          // Drawer só é atribuído se for tela pequena
          drawer: isDesktop ? null : const AppSidebar(),

          body: Row(
            children: [
              // Se for tela grande, a Sidebar fica sempre visível e fixa na esquerda
              if (isDesktop) 
                const SizedBox(
                  width: 280, // Largura fixa da Sidebar
                  child: AppSidebar(),
                ),
              
              // Divisória vertical para ecrãs grandes
              if (isDesktop) 
                VerticalDivider(width: 1, color: Theme.of(context).colorScheme.secondary.withOpacity(0.2)),

              // O MIOLO DA APLICAÇÃO (Onde as telas de Ativos, Dispositivos, etc. vão aparecer)
              Expanded(
                child: Navigator(
                  key: Get.nestedKey(HomeController.nestedNavigationId),
                  // A Rota inicial do Navigator aninhado
                  initialRoute: '/assets',
                  onGenerateRoute: (settings) {
                    // Aqui definimos o que renderizar para cada rota interna
                    Widget page;
                    switch (settings.name) {
                      case '/assets':
                        // Temporário até criarmos a feature de Ativos
                        page = const Center(child: Text('Feature de Ativos: Listagem em breve!')); 
                        break;
                      case '/dashboard':
                        page = const Center(child: Text('Feature de Dashboard (Futuro)'));
                        break;
                      case '/devices':
                        page = const Center(child: Text('Feature de Dispositivos (Futuro)'));
                        break;
                      case '/installations':
                        page = const Center(child: Text('Feature de Instalações (Futuro)'));
                        break;
                      case '/settings':
                        page = const Center(child: Text('Feature de Configurações (Futuro)'));
                        break;
                      default:
                        page = const Center(child: Text('Página não encontrada.'));
                    }

                    // Transição suave de Fade ao trocar de ecrã no menu
                    return GetPageRoute(
                      page: () => page,
                      transition: Transition.fadeIn,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}