import 'package:flutter/material.dart';

/// Componente padronizado para exibir o estado de carregamento.
class AppLoading extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoading({
    super.key,
    this.color,
    this.size = 24.0, // Tamanho padrão que não quebra layouts
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          // Se não passarmos cor, ele usa a cor primária do Tema
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
          strokeWidth: 3.0, // Uma espessura mais elegante
        ),
      ),
    );
  }
}