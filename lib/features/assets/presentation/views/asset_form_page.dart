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
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Detalhes do Ativo' : 'Novo Ativo'),
      ),
      body: Obx(() {
        if (controller.isLoadingDetails.value) {
          return const AppLoading();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBindingSection(context),
                const SizedBox(height: 16),
                _buildIdentificationSection(context),
                const SizedBox(height: 16),
                _buildDocumentationSection(context),
                const SizedBox(height: 16),
                _buildConnectivitySection(context),
                if (controller.isEditing) ...[
                  const SizedBox(height: 16),
                  _buildEngineSection(context),
                  const SizedBox(height: 16),
                  _buildAdditionalSection(context),
                ],
                const SizedBox(height: 24),
                _buildSaveButton(),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- SEÇÃO 1: VINCULAÇÕES E DEPENDÊNCIAS ---
  Widget _buildBindingSection(BuildContext context) {
    return _Section(
      title: 'Informações de Vinculação',
      children: [
        AppAutocomplete<CustomerEntity>(
          label: 'Cliente Proprietário *',
          hintText: 'Digite para buscar um cliente...',
          selectedItem: controller.selectedCustomer.value,
          asyncItems: controller.searchCustomers,
          itemAsString: (customer) => customer.name,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (val) => controller.selectedCustomer.value = val,
        ),
        const SizedBox(height: 16),
        AppAutocomplete<ManufacturerEntity>(
          label: 'Fabricante *',
          hintText: 'Buscar fabricante...',
          selectedItem: controller.selectedManufacturer.value,
          asyncItems: controller.searchManufacturers,
          itemAsString: (manuf) => manuf.name,
          compareFn: (a, b) => a.id == b.id,
          onChanged: controller.onManufacturerChanged,
        ),
        const SizedBox(height: 16),
        AppAutocomplete<ModelEntity>(
          label: 'Modelo *',
          hintText: controller.selectedManufacturer.value == null
              ? 'Selecione um fabricante primeiro'
              : 'Buscar modelo...',
          selectedItem: controller.selectedModel.value,
          asyncItems: controller.searchModels,
          itemAsString: (model) => model.name,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (val) => controller.selectedModel.value = val,
        ),
      ],
    );
  }

  // --- SEÇÃO 2: IDENTIFICAÇÃO DO ATIVO ---
  Widget _buildIdentificationSection(BuildContext context) {
    return _Section(
      title: 'Identificação do Ativo',
      children: [
        AppAutocomplete<AssetTypeEntity>(
          label: 'Tipo de Ativo *',
          hintText: 'Selecione o tipo de ativo...',
          selectedItem: controller.selectedAssetType.value,
          asyncItems: controller.searchAssetTypes,
          itemAsString: (type) => type.name,
          compareFn: (a, b) => a.id == b.id,
          onChanged: (val) => controller.selectedAssetType.value = val,
          showSearchBox: false,
        ),
        const SizedBox(height: 16),
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
        AppTextField(
          label: 'Número do Chassi',
          controller: controller.chassisController,
        ),
        const SizedBox(height: 16),
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
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Ano Modelo',
                keyboardType: TextInputType.number,
                controller: controller.modelYearController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SEÇÃO 3: DOCUMENTAÇÃO ---
  Widget _buildDocumentationSection(BuildContext context) {
    return _Section(
      title: 'Documentação',
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Nota Fiscal',
                controller: controller.invoiceController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Centro de Custo',
                controller: controller.costCenterController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: 'Observações',
          controller: controller.noteController,
        ),
      ],
    );
  }

  // --- SEÇÃO 4: CONECTIVIDADE ---
  Widget _buildConnectivitySection(BuildContext context) {
    return _Section(
      title: 'Conectividade',
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Limite Offline (min)',
                keyboardType: TextInputType.number,
                controller: controller.offlineThresholdController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Notif. Offline (min)',
                keyboardType: TextInputType.number,
                controller: controller.offlineNotificationThresholdController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SEÇÃO 5: MOTOR (apenas edição) ---
  Widget _buildEngineSection(BuildContext context) {
    return _Section(
      title: 'Motor',
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Tipo do Motor',
                controller: controller.engineTypeController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Nº de Série do Motor',
                controller: controller.engineSerialNumberController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SEÇÃO 6: CAMPOS ADICIONAIS (apenas edição) ---
  Widget _buildAdditionalSection(BuildContext context) {
    return _Section(
      title: 'Campos Adicionais',
      children: [
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Adicional 1',
                controller: controller.additional1Controller,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Adicional 2',
                controller: controller.additional2Controller,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                label: 'Adicional 3',
                controller: controller.additional3Controller,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                label: 'Adicional 4',
                controller: controller.additional4Controller,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: controller.isEditing ? 'Atualizar Ativo' : 'Criar Ativo',
        isLoading: controller.isSaving.value,
        onPressed: controller.saveAsset,
      ),
    );
  }
}

/// Cartão de seção do formulário com título e conteúdo.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
