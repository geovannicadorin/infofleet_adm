import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/asset_type_entity.dart'; // Import da nova entidade
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/manufacturer_entity.dart';
import '../../domain/entities/model_entity.dart';
import '../../domain/repositories/i_asset_repository.dart';
import 'asset_list_controller.dart';

class AssetFormController extends GetxController {
  final IAssetRepository _repository;

  AssetFormController(this._repository);

  // Identificador do Ativo (Nulo = Modo Criação, Preenchido = Modo Edição)
  String? assetId;
  bool get isEditing => assetId != null;

  // Controladores de Estado (UI)
  final RxBool isLoadingDetails = false.obs;
  final RxBool isSaving = false.obs;
  final formKey = GlobalKey<FormState>();

  // Controladores de Texto
  final plateController = TextEditingController();
  final nicknameController = TextEditingController();
  final chassisController = TextEditingController();
  final colorController = TextEditingController();
  final manufacturingYearController = TextEditingController();

  // Controladores de Autocomplete / Select (Seleções)
  final Rx<CustomerEntity?> selectedCustomer = Rx<CustomerEntity?>(null);
  final Rx<ManufacturerEntity?> selectedManufacturer = Rx<ManufacturerEntity?>(null);
  final Rx<ModelEntity?> selectedModel = Rx<ModelEntity?>(null);

  // SOLUÇÃO DO ERRO: Adicionada a propriedade observável para o Tipo de Ativo
  final Rx<AssetTypeEntity?> selectedAssetType = Rx<AssetTypeEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    // Recebe o ID da rota anterior, se existir
    assetId = Get.arguments as String?;

    if (isEditing) {
      _loadAssetDetails();
    }
  }

  /// Carrega os detalhes do Ativo e preenche os campos do formulário
  Future<void> _loadAssetDetails() async {
    isLoadingDetails.value = true;
    try {
      final asset = await _repository.getAssetDetails(assetId!);

      // Preenche os campos de texto
      plateController.text = asset.plate;
      nicknameController.text = asset.nickname;
      chassisController.text = asset.chassisNumber;
      colorController.text = asset.color ?? '';
      manufacturingYearController.text = asset.manufacturingYear?.toString() ?? '';

      // Preenche os Autocompletes com instâncias "Fake/Iniciais" apenas para mostrar o nome na UI
      if (asset.customerId != null) {
        selectedCustomer.value = CustomerEntity(id: asset.customerId!, name: asset.ownerName);
      }
      if (asset.manufacturerId != null) {
        selectedManufacturer.value = ManufacturerEntity(id: asset.manufacturerId!, name: asset.manufacturerName);
      }
      if (asset.modelId != null) {
        selectedModel.value = ModelEntity(id: asset.modelId!, name: asset.modelName);
      }

      // SOLUÇÃO ADICIONAL: Se a API trouxer o Tipo de Ativo no detalhe, carregamos ele no Select
      if (asset.assetType != null) {
        // Buscamos a lista para encontrar o objeto correspondente ao ID vindo do C#
        final types = await _repository.getAssetTypes();
        selectedAssetType.value = types.firstWhereOrNull((t) => t.id == asset.assetType);
      }

    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os detalhes do ativo.');
      Get.back(); // Volta para a lista se falhar
    } finally {
      isLoadingDetails.value = false;
    }
  }

  /// Lida com a mudança de Fabricante (Limpa o modelo selecionado)
  void onManufacturerChanged(ManufacturerEntity? manufacturer) {
    selectedManufacturer.value = manufacturer;
    selectedModel.value = null; // Reseta o modelo, pois depende do fabricante
  }

  /// Monta o Payload e decide se faz POST ou PUT
  Future<void> saveAsset() async {
    if (!formKey.currentState!.validate()) return;

    // Validações manuais para as seleções obrigatórias
    if (selectedCustomer.value == null ||
        selectedManufacturer.value == null ||
        selectedModel.value == null ||
        selectedAssetType.value == null) { // Adicionada validação do Tipo de Ativo
      Get.snackbar('Atenção', 'Por favor, preencha os campos obrigatórios de seleção (*).');
      return;
    }

    isSaving.value = true;

    try {
      // Monta o JSON exato exigido na sua model do backend C#
      final payload = {
        if (isEditing) "id": assetId, // O PUT exige o ID no payload
        "customerId": selectedCustomer.value!.id,
        "manufacturerId": selectedManufacturer.value!.id,
        "modelId": selectedModel.value!.id,
        "assetType": selectedAssetType.value!.id, // SOLUÇÃO: Envia o ID numérico correto (1 a 47)
        "plate": plateController.text,
        "nickname": nicknameController.text,
        "chassisNumber": chassisController.text,
        "color": colorController.text,
        "manufacturingYear": int.tryParse(manufacturingYearController.text) ?? 0,
      };

      if (isEditing) {
        await _repository.updateAsset(payload);
        Get.snackbar('Sucesso', 'Ativo atualizado com sucesso!');
      } else {
        await _repository.createAsset(payload);
        Get.snackbar('Sucesso', 'Ativo criado com sucesso!');
      }

      // Atualiza a lista (se ainda estiver viva em memória) e fecha o formulário
      if (Get.isRegistered<AssetListController>()) {
        Get.find<AssetListController>().onRefresh();
      }
      Get.back();

    } catch (e) {
      Get.snackbar('Erro ao Salvar', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  // Métodos expostos para os Autocompletes buscarem dados
  Future<List<CustomerEntity>> searchCustomers(String query) => _repository.searchCustomers(query, 1);
  Future<List<ManufacturerEntity>> searchManufacturers(String query) => _repository.getManufacturers();

  // SOLUÇÃO DO ERRO: Adicionado o método que a View chama para o Select
  Future<List<AssetTypeEntity>> searchAssetTypes(String query) => _repository.getAssetTypes();

  Future<List<ModelEntity>> searchModels(String query) {
    if (selectedManufacturer.value == null) return Future.value([]);
    return _repository.getModels(selectedManufacturer.value!.id, query);
  }

  @override
  void onClose() {
    plateController.dispose();
    nicknameController.dispose();
    chassisController.dispose();
    colorController.dispose();
    manufacturingYearController.dispose();
    super.onClose();
  }
}