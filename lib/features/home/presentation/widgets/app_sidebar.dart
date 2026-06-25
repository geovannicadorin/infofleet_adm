import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class AppSidebar extends GetView<HomeController> {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      elevation: 0,
      child: Column(
        children: [
          // Header com a Marca
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.1))),
            ),
            child: Row(
              children: [
                Icon(Icons.directions_car, size: 32, color: theme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Infofleet ADM',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          
          // Lista de Módulos (Menu)
          Expanded(
            child: ListView.builder(
              itemCount: controller.menuItems.length,
              itemBuilder: (context, index) {
                final item = controller.menuItems[index];
                
                return Obx(() {
                  final isActive = controller.currentRoute.value == item.route;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      leading: Icon(
                        item.icon,
                        color: isActive ? theme.primaryColor : theme.colorScheme.secondary,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          color: isActive ? theme.primaryColor : theme.colorScheme.secondary,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      tileColor: isActive ? theme.primaryColor.withOpacity(0.1) : Colors.transparent,
                      onTap: () => controller.navigateTo(item.route),
                    ),
                  );
                });
              },
            ),
          ),

          // Rodapé: Botão de Logout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              leading: Icon(Icons.logout, color: theme.colorScheme.error),
              title: Text('Sair', style: TextStyle(color: theme.colorScheme.error)),
              onTap: controller.logout,
            ),
          ),
        ],
      ),
    );
  }
}