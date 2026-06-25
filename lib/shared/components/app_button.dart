import 'package:flutter/material.dart';
import 'app_loading.dart';

/// Botão principal do Design System. 
/// Suporta estado de carregamento e variações visuais (Preenchido ou Contornado).
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Busca as cores do tema que configuramos anteriormente
    final theme = Theme.of(context);
    final primaryColor = backgroundColor ?? theme.primaryColor;

    // Se estiver em modo Outlined (Apenas borda)
    if (isOutlined) {
      return OutlinedButton(
        // Desativa o botão se estiver a carregar ou se onPressed for nulo
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
        child: _buildChild(primaryColor),
      );
    }

    // Botão Preenchido (Padrão)
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 0, // Design flat e moderno
      ),
      child: _buildChild(Colors.white),
    );
  }

  // Método auxiliar para decidir se mostra o texto ou o loading
  Widget _buildChild(Color contentColor) {
    if (isLoading) {
      return AppLoading(color: contentColor, size: 20);
    }
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}