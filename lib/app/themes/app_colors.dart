import 'package:flutter/material.dart';

/// Classe responsável por centralizar todas as cores do Design System.
/// Baseado no :root CSS original do projeto.
class AppColors {
  // Construtor privado para evitar que a classe seja instanciada.
  AppColors._();

  // --- Cores Principais ---
  static const Color primary = Color(0xFF7367F0);
  static const Color secondary = Color(0xFF82868B);

  // --- Cores da Marca OnBoard (logo) ---
  static const Color onboardGreen = Color(0xFF2EC04B);
  static const Color onboardNavy = Color(0xFF221C46);
  static const Color onboardGreenTint = Color(0xFFF1FBF4);
  
  // --- Cores de Feedback (Status) ---
  static const Color success = Color(0xFF28C76F);
  static const Color info = Color(0xFF00CFE8);
  static const Color warning = Color(0xFFFF9F43);
  static const Color danger = Color(0xFFEA5455);
  
  // --- Cores de Fundo e Texto ---
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF4B4B4B);
  static const Color white = Color(0xFFFFFFFF);
  
  // --- Escala de Cinzas ---
  static const Color gray = Color(0xFFB8C2CC);
  static const Color grayDark = Color(0xFF1E1E1E);

  // --- Outras Cores do CSS (Opcional, mas útil ter mapeado) ---
  static const Color blue = Color(0xFF00CFE8);
  static const Color indigo = Color(0xFF6610F2);
  static const Color purple = Color(0xFF7367F0);
  static const Color pink = Color(0xFFE83E8C);
  static const Color red = Color(0xFFEA5455);
  static const Color orange = Color(0xFFFF9F43);
  static const Color yellow = Color(0xFFFFC107);
  static const Color green = Color(0xFF28C76F);
  static const Color teal = Color(0xFF20C997);
  static const Color cyan = Color(0xFF17A2B8);
}