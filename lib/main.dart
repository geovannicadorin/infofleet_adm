import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart'; // A nossa configuração de Tema
import 'core/api/api_client.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('pt_BR');

  // --- 1. INICIALIZAÇÃO ASSÍNCRONA DA AUTENTICAÇÃO ---
  // Utilizamos Get.putAsync para aguardar que o serviço leia o Token do SecureStorage.
  await Get.putAsync<AuthService>(() => AuthService().init(), permanent: true);
  
  // --- 2. INICIALIZAÇÃO DA API (DIO) ---
  Get.put<Dio>(ApiClient().dio, permanent: true);

  runApp(const InfofleetApp());
}

class InfofleetApp extends StatelessWidget {
  const InfofleetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Infofleet OnBoard ADM',
      debugShowCheckedModeBanner: false,

      // --- CONFIGURAÇÃO DO TEMA CORPORATIVO ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // --- SISTEMA DE NAVEGAÇÃO E PROTEÇÃO ---
      // A Splash é o ponto de entrada e decide o destino (Home/Login).
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}