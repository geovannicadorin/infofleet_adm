import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../app/routes/app_routes.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;

  AuthController(this._loginUseCase);

  // Controladores do Formulário
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Estado de carregamento (Reativo)
  final RxBool isLoading = false.obs;
  // Estado para mostrar/esconder palavra-passe
  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> doLogin() async {
    // Valida se os campos não estão vazios/inválidos
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      await _loginUseCase(
        emailController.text.trim(),
        passwordController.text,
      );
      
      // Login com sucesso e perfil é SYSADMIN! Redireciona para Home.
      Get.offAllNamed(Routes.HOME);
      
    } on AuthException catch (e) {
      // Mostra o erro da Regra de Negócio (ex: Não é SYSADMIN)
      Get.snackbar(
        'Falha no Login',
        e.message,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}