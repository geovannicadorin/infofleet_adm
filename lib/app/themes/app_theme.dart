import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Classe responsável por agrupar as configurações de tema (Claro e Escuro)
class AppTheme {
  AppTheme._();

  /// Configuração do Tema Claro (Light Theme)
  static ThemeData get lightTheme {
    return ThemeData(
      // Cores principais do tema
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.light, // Fundo principal da aplicação
      
      // Mapeamento moderno do Material 3 para o ColorScheme
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.white, // Fundo de cartões (Cards) e menus
        error: AppColors.danger,
      ),

      // Aplica a nossa tipografia (Montserrat)
      textTheme: AppTypography.getTextTheme(),

      // Podemos já definir um estilo padrão para o AppBar baseado nas cores
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0, // Sem sombra para um design mais plano e moderno
      ),
      
      useMaterial3: true,
    );
  }

  // O Tema Escuro pode ser configurado posteriormente,
  // mas a base já fica preparada aqui.
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.grayDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.dark,
        error: AppColors.danger,
      ),
      textTheme: AppTypography.getTextTheme().apply(
        bodyColor: AppColors.light,
        displayColor: AppColors.light,
      ),
      useMaterial3: true,
    );
  }
}