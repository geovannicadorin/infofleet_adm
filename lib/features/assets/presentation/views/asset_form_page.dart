import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- Imports do Design System ---
import '../../../../../shared/components/app_autocomplete.dart';
import '../../../../../shared/components/app_button.dart';
import '../../../../../shared/components/app_card.dart';
import '../../../../../shared/components/app_loading.dart';
import '../../../../../shared/components/app_text_field.dart';

// --- Imports da Feature ---
import '../../domain/entities/asset_type_entity.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/manufacturer_entity.dart';
import '../../domain/entities/model_entity.dart';
import '../controllers/asset_form_controller.dart';

class AssetFormPage extends GetView<AssetFormController> {
  const AssetFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // O título adapta-se automaticamente ao modo (Criação vs Edição)
        title: Text(controller.isEditing ? 'Detalhes do Ativo' : 'Novo Ativo'),
      ),
      body: Obx(() {
        // Bloqueia a tela com um loading central enquanto busca os detalhes da API (GET /id)
        if (controller.isLoadingDetails.value) {
          return const AppLoading();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SEÇÃO 1: VINCULAÇÕES E DEPENDÊNCIAS ---
                  Text('Informações de Vinculação', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),

                  // 1. Cliente (Autosuggest)
                  AppAutocomplete<CustomerEntity>(
                    label: 'Cliente Proprietário *',
                    hintText: 'Digite para buscar um cliente...',
                    selectedItem: controller.selectedCustomer.value,
                    asyncItems: controller.searchCustomers,
                    itemAsString: (customer) => customer.name,
                    onChanged: (val) => controller.selectedCustomer.value = val,
                  ),
                  const SizedBox(height: 16),

                  // 2. Fabricante / Marca (Autosuggest)
                  AppAutocomplete<ManufacturerEntity>(
                    label: 'Fabricante *',
                    hintText: 'Buscar fabricante...',
                    selectedItem: controller.selectedManufacturer.value,
                    asyncItems: controller.searchManufacturers,
                    itemAsString: (manuf) => manuf.name,
                    onChanged: controller.onManufacturerChanged, // Lógica em cascata: limpa o modelo!
                  ),
                  const SizedBox(height: 16),

                  // 3. Modelo (Autosuggest com dependência)
                  AppAutocomplete<ModelEntity>(
                    label: 'Modelo *',
                    hintText: controller.selectedManufacturer.value == null 
                        ? 'Selecione um fabricante primeiro' 
                        : 'Buscar modelo...',
                    selectedItem: controller.selectedModel.value,
                    asyncItems: controller.searchModels,
                    itemAsString: (model) => model.name,
                    onChanged: (val) => controller.selectedModel.value = val,
                  ),
                  
                  const Divider(height: 48),

                  // --- SEÇÃO 2: IDENTIFICAÇÃO DO ATIVO ---
                  Text('Identificação do Ativo', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16),

                  // 4. Tipo de Ativo (SELECT CLÁSSICO - Sem barra de pesquisa)
                  AppAutocomplete<AssetTypeEntity>(
                    label: 'Tipo de Ativo *',
                    hintText: 'Selecione o tipo de ativo...',
                    selectedItem: controller.selectedAssetType.value,
                    asyncItems: controller.searchAssetTypes, // Traz a lista estática
                    itemAsString: (type) => type.name,
                    onChanged: (val) => controller.selectedAssetType.value = val,
                    showSearchBox: false, // <-- A propriedade que transforma o Autosuggest num Select
                  ),
                  const SizedBox(height: 16),

                  // 5. Placa e Apelido
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Placa',
                          controller: controller.plateController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: 'Apelido (Frota)',
                          controller: controller.nicknameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // 6. Chassi
                  AppTextField(
                    label: 'Número do Chassi',
                    controller: controller.chassisController,
                  ),
                  const SizedBox(height: 16),

                  // 7. Cor e Ano
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Cor',
                          controller: controller.colorController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppTextField(
                          label: 'Ano Fab.',
                          keyboardType: TextInputType.number,
                          controller: controller.manufacturingYearController,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  
                  // --- SEÇÃO 3: AÇÃO ---
                  // Botão reativo que mostra o loading ao enviar os dados (POST/PUT)
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      text: controller.isEditing ? 'Atualizar Ativo' : 'Criar Ativo',
                      isLoading: controller.isSaving.value,
                      onPressed: controller.saveAsset,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}