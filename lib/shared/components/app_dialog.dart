import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_button.dart';

/// Classe utilitária para exibição de modais/dialogs padronizados.
class AppDialog {
  AppDialog._();

  static Future<void> showConfirmation({
    required String title,
    required String description,
    required VoidCallback onConfirm,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    bool isDestructive = false, // true para ações como "Excluir" (fica vermelho)
  }) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              cancelText,
              style: TextStyle(color: Theme.of(Get.context!).colorScheme.secondary),
            ),
          ),
          AppButton(
            text: confirmText,
            backgroundColor: isDestructive ? Theme.of(Get.context!).colorScheme.error : null,
            onPressed: () {
              Get.back(); // Fecha o modal
              onConfirm(); // Executa a ação
            },
          ),
        ],
      ),
    );
  }
}