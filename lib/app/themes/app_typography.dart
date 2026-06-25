import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Classe responsável pela tipografia do aplicativo.
class AppTypography {
  AppTypography._();

  /// Define o TextTheme padrão utilizando a fonte Montserrat.
  /// Aqui mapeamos os tamanhos base.
  static TextTheme getTextTheme() {
    return GoogleFonts.montserratTextTheme().copyWith(
      // Títulos maiores (ex: Headers de telas)
      displayLarge: GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.dark,
      ),
      // Títulos médios
      titleLarge: GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.dark,
      ),
      // Texto normal (ex: descrições, corpo do texto)
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.dark,
      ),
      // Textos pequenos (ex: legendas)
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.secondary,
      ),
    );
  }
}