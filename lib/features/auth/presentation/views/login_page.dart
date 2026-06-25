import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/components/app_button.dart';
import '../../../../shared/components/app_card.dart';
import '../../../../shared/components/app_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: AppCard(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo ou Título da Aplicação
                  Icon(Icons.directions_car, size: 64, color: theme.primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'Infofleet OnBoard ADM',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Painel Administrativo',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  // Campo E-mail
                  AppTextField(
                    label: 'E-mail',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  const SizedBox(height: 16),

                  // Campo Palavra-passe
                  Obx(() => AppTextField(
                    label: 'Palavra-passe',
                    controller: controller.passwordController,
                    obscureText: controller.obscurePassword.value,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value 
                            ? Icons.visibility_off 
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
                  )),
                  const SizedBox(height: 32),

                  // Botão Entrar com Loading reativo
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: 'Entrar',
                      isLoading: controller.isLoading.value,
                      onPressed: controller.doLogin,
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}