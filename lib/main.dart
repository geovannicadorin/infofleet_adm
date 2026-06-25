import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart'; // A nossa configuração de Tema
import 'core/api/api_client.dart';
import 'core/services/auth_service.dart';
import 'app/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

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
    final authService = Get.find<AuthService>();
    final initialRoute = authService.isLoggedIn.value ? Routes.HOME : AppPages.INITIAL;

    return GetMaterialApp(
      title: 'Infofleet OnBoard ADM',
      debugShowCheckedModeBanner: false, 
      
      // --- CONFIGURAÇÃO DO TEMA CORPORATIVO ---
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, 
      
      // --- SISTEMA DE NAVEGAÇÃO E PROTEÇÃO ---
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}