import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// --- Imports do Design System ---
import '../../../../../shared/components/app_avatar.dart';
import '../../../../../shared/components/app_button.dart';
import '../../../../../shared/components/app_card.dart';
import '../../../../../shared/components/app_pagination.dart';
import '../../../../../shared/components/app_text_field.dart';
import '../../../../../shared/components/app_autocomplete.dart';
import '../../../../../shared/components/app_multi_select.dart';

// --- Imports da Feature ---
import '../../../../../app/routes/app_routes.dart';

// Entidades auxiliares
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/asset_type_entity.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/manufacturer_entity.dart';
import '../../domain/entities/model_entity.dart';
import '../../domain/entities/work_status_entity.dart';
import '../controllers/asset_list_controller.dart';

class AssetListPage extends GetView<AssetListController> {
  const AssetListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Ativos'),
        actions: [
          // Botão de Filtros Avançados
          IconButton(
            icon: Obx(() {
              // UX: Muda o ícone visualmente se houver algum filtro aplicado
              final hasFilters = controller.filterCustomer.value != null ||
                  controller.filterAssetType.value != null ||
                  controller.filterStatuses.isNotEmpty ||
                  controller.filterBrand.value != null;
              
              return Icon(
                hasFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                color: hasFilters ? theme.colorScheme.surface : null,
              );
            }),
            tooltip: 'Filtros Avançados',
            onPressed: () => _showFilterBottomSheet(context, theme),
          ),
          // Botão de Novo Ativo
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Novo Ativo',
            onPressed: () => Get.toNamed(Routes.ASSETS_FORM),
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. BARRA DE BUSCA RÁPIDA ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppTextField(
              label: 'Pesquisar Ativos',
              hintText: 'Placa, Apelido ou Chassi...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),

          // --- 2. LISTA PAGINADA DE ATIVOS ---
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.onRefresh,
              child: AppPagination<AssetEntity>(
                pagingController: controller.pagingController,
                emptyMessage: 'Nenhum ativo encontrado com estes filtros.',
                itemBuilder: (context, asset, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: AppCard(
                      onTap: () {
                        // Navega para o formulário passando o ID (Modo Edição/Detalhe)
                        Get.toNamed(Routes.ASSETS_FORM, arguments: asset.id);
                      },
                      child: Row(
                        children: [
                          // Avatar Inteligente (Imagem ou Iniciais)
                          AppAvatar(
                            imageUrl: asset.iconUrl,
                            fallbackInitials: asset.avatarInitials,
                            radius: 28,
                          ),
                          const SizedBox(width: 16),
                          
                          // Dados Principais do Ativo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  asset.displayIdentifier,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${asset.manufacturerName} • ${asset.modelName}',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 8),
                                _buildConnectionStatus(asset, theme),
                              ],
                            ),
                          ),
                          
                          // Ícone de Navegação
                          Icon(Icons.chevron_right, color: theme.colorScheme.secondary),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  /// Constrói o indicador de conexão formatado (Intl pt-BR)
  Widget _buildConnectionStatus(AssetEntity asset, ThemeData theme) {
    if (asset.lastConnectionTime == null) {
      return Row(
        children: [
          Icon(Icons.wifi_off, size: 14, color: theme.colorScheme.error),
          const SizedBox(width: 4),
          Text('Nunca conectado', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
        ],
      );
    }

    final formattedDate = DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR').format(asset.lastConnectionTime!);
    return Row(
      children: [
        Icon(Icons.wifi, size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 4),
        Text(formattedDate, style: TextStyle(color: theme.colorScheme.secondary, fontSize: 12)),
      ],
    );
  }

  /// Exibe o Bottom Sheet com os Filtros Avançados
  void _showFilterBottomSheet(BuildContext context, ThemeData theme) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0, bottom: 32.0),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cabeçalho
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filtros Avançados', style: theme.textTheme.titleLarge),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 1. Cliente (Autosuggest API)
              Obx(() => AppAutocomplete<CustomerEntity>(
                label: 'Cliente Proprietário',
                hintText: 'Buscar por nome ou documento...',
                selectedItem: controller.filterCustomer.value,
                asyncItems: controller.searchCustomers,
                itemAsString: (customer) => customer.name,
                onChanged: (val) => controller.filterCustomer.value = val,
              )),
              const SizedBox(height: 16),

              // 2. Tipo de Ativo (SELECT CLÁSSICO - Sem barra de pesquisa)
              Obx(() => AppAutocomplete<AssetTypeEntity>(
                label: 'Tipo de Ativo',
                hintText: 'Ex: Carro, Caminhão...',
                selectedItem: controller.filterAssetType.value,
                asyncItems: controller.getAssetTypes,
                itemAsString: (type) => type.name,
                onChanged: (val) => controller.filterAssetType.value = val,
                showSearchBox: false, // <-- Propriedade ajustada conforme a regra da API
              )),
              const SizedBox(height: 16),

              // 3. Marca / Fabricante (Autosuggest API)
              Obx(() => AppAutocomplete<ManufacturerEntity>(
                label: 'Fabricante',
                hintText: 'Ex: Volvo, Scania...',
                selectedItem: controller.filterBrand.value,
                asyncItems: controller.searchBrands,
                itemAsString: (brand) => brand.name,
                onChanged: controller.onBrandFilterChanged, // Reseta o modelo
              )),
              const SizedBox(height: 16),

              // 4. Modelo (Cascata)
              Obx(() => AppAutocomplete<ModelEntity>(
                label: 'Modelo',
                hintText: controller.filterBrand.value == null 
                    ? 'Selecione um fabricante primeiro' 
                    : 'Buscar modelo...',
                selectedItem: controller.filterModel.value,
                asyncItems: controller.searchModels,
                itemAsString: (model) => model.name,
                onChanged: (val) => controller.filterModel.value = val,
              )),
              const SizedBox(height: 16),

              // 5. Status de Operação (MultiSelect API)
              Obx(() => AppMultiSelect<WorkStatusEntity>(
                label: 'Status de Operação',
                hintText: 'Selecione um ou mais status...',
                selectedItems: controller.filterStatuses.toList(),
                asyncItems: controller.getWorkStatuses,
                itemAsString: (status) => status.description,
                onChanged: (val) => controller.filterStatuses.assignAll(val),
              )),
              
              const SizedBox(height: 32),

              // --- BOTÕES DE AÇÃO ---
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Limpar',
                      isOutlined: true,
                      onPressed: controller.clearFilters,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      text: 'Aplicar Filtros',
                      onPressed: controller.applyFilters,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Garante que o teclado não cubra os campos
      ignoreSafeArea: false,
    );
  }
}