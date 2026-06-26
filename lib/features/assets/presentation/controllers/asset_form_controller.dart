import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/asset_type_entity.dart';
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

  // --- Controladores de Texto ---
  final plateController = TextEditingController();
  final nicknameController = TextEditingController();
  final chassisController = TextEditingController();
  final colorController = TextEditingController();
  final manufacturingYearController = TextEditingController();
  final modelYearController = TextEditingController();
  final invoiceController = TextEditingController();
  final costCenterController = TextEditingController();
  final noteController = TextEditingController();
  final engineTypeController = TextEditingController();
  final engineSerialNumberController = TextEditingController();
  final additional1Controller = TextEditingController();
  final additional2Controller = TextEditingController();
  final additional3Controller = TextEditingController();
  final additional4Controller = TextEditingController();
  final offlineThresholdController = TextEditingController();
  final offlineNotificationThresholdController = TextEditingController();

  late final List<TextEditingController> _allTextControllers = [
    plateController,
    nicknameController,
    chassisController,
    colorController,
    manufacturingYearController,
    modelYearController,
    invoiceController,
    costCenterController,
    noteController,
    engineTypeController,
    engineSerialNumberController,
    additional1Controller,
    additional2Controller,
    additional3Controller,
    additional4Controller,
    offlineThresholdController,
    offlineNotificationThresholdController,
  ];

  // --- Seleções (Autocomplete / Select) ---
  final Rx<CustomerEntity?> selectedCustomer = Rx<CustomerEntity?>(null);
  final Rx<ManufacturerEntity?> selectedManufacturer = Rx<ManufacturerEntity?>(null);
  final Rx<ModelEntity?> selectedModel = Rx<ModelEntity?>(null);
  final Rx<AssetTypeEntity?> selectedAssetType = Rx<AssetTypeEntity?>(null);

  @override
  void onInit() {
    super.onInit();
    assetId = Get.arguments as String?;
    if (isEditing) {
      _loadAssetDetails();
    }
  }

  /// Carrega os detalhes do Ativo e preenche os campos do formulário.
  Future<void> _loadAssetDetails() async {
    isLoadingDetails.value = true;
    try {
      final asset = await _repository.getAssetDetails(assetId!);

      // Campos de texto
      plateController.text = asset.plate;
      nicknameController.text = asset.nickname;
      chassisController.text = asset.chassisNumber;
      colorController.text = asset.color ?? '';
      manufacturingYearController.text = asset.manufacturingYear?.toString() ?? '';
      modelYearController.text = asset.modelYear?.toString() ?? '';
      invoiceController.text = asset.invoice ?? '';
      costCenterController.text = asset.costCenter ?? '';
      noteController.text = asset.note ?? '';
      engineTypeController.text = asset.engineType ?? '';
      engineSerialNumberController.text = asset.engineSerialNumber ?? '';
      additional1Controller.text = asset.additional1 ?? '';
      additional2Controller.text = asset.additional2 ?? '';
      additional3Controller.text = asset.additional3 ?? '';
      additional4Controller.text = asset.additional4 ?? '';
      offlineThresholdController.text = asset.offlineThreshold?.toString() ?? '';
      offlineNotificationThresholdController.text =
          asset.offlineNotificationThreshold?.toString() ?? '';

      // Proprietário (a resposta já traz o nome)
      if (asset.customerId != null) {
        selectedCustomer.value =
            CustomerEntity(id: asset.customerId!, name: asset.ownerName);
      }

      // Fabricante: a resposta NÃO traz o nome, apenas o id.
      // Resolvemos o nome real consultando a lista de fabricantes.
      if (asset.manufacturerId != null) {
        await _resolveManufacturer(asset.manufacturerId!, asset.manufacturerName);
      }

      // Modelo de catálogo: usa o nome que vem em modelIdName (fallback modelName).
      if (asset.modelId != null) {
        selectedModel.value = ModelEntity(
          id: asset.modelId!,
          name: asset.modelIdName ?? asset.modelName,
        );
      }

      // Tipo de Ativo: resolve o objeto a partir do id numérico.
      if (asset.assetType != null) {
        final types = await _repository.getAssetTypes();
        selectedAssetType.value =
            types.firstWhereOrNull((t) => t.id == asset.assetType);
      }
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar os detalhes do ativo.');
      Get.back();
    } finally {
      isLoadingDetails.value = false;
    }
  }

  /// Busca o nome real do fabricante na lista; se não encontrar, usa um fallback.
  Future<void> _resolveManufacturer(String id, String fallbackName) async {
    try {
      final manufacturers = await _repository.getManufacturers();
      selectedManufacturer.value =
          manufacturers.firstWhereOrNull((m) => m.id == id) ??
              ManufacturerEntity(id: id, name: fallbackName);
    } catch (_) {
      selectedManufacturer.value = ManufacturerEntity(id: id, name: fallbackName);
    }
  }

  /// Lida com a mudança de Fabricante (Limpa o modelo selecionado).
  void onManufacturerChanged(ManufacturerEntity? manufacturer) {
    selectedManufacturer.value = manufacturer;
    selectedModel.value = null; // O modelo depende do fabricante.
  }

  /// Monta o Payload e decide se faz POST (criar) ou PUT (atualizar).
  Future<void> saveAsset() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCustomer.value == null ||
        selectedManufacturer.value == null ||
        selectedModel.value == null ||
        selectedAssetType.value == null) {
      Get.snackbar('Atenção',
          'Preencha os campos obrigatórios de seleção (Cliente, Fabricante, Modelo e Tipo).');
      return;
    }

    isSaving.value = true;
    try {
      final payload = _buildPayload();

      if (isEditing) {
        await _repository.updateAsset(payload);
        Get.snackbar('Sucesso', 'Ativo atualizado com sucesso!');
      } else {
        await _repository.createAsset(payload);
        Get.snackbar('Sucesso', 'Ativo criado com sucesso!');
      }

      if (Get.isRegistered<AssetListController>()) {
        Get.find<AssetListController>().onRefresh();
      }
      Get.back();
    } catch (e) {
      Get.snackbar('Erro ao Salvar', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSaving.value = false;
    }
  }

  /// Constrói o corpo da requisição alinhado às models Create/Update do backend.
  Map<String, dynamic> _buildPayload() {
    final payload = <String, dynamic>{
      if (isEditing) 'id': assetId,
      'customerId': selectedCustomer.value!.id,
      'manufacturerId': selectedManufacturer.value!.id,
      'modelId': selectedModel.value!.id,
      // ModelName é obrigatório no backend; usamos o nome do modelo selecionado.
      'modelName': selectedModel.value!.name,
      'assetType': selectedAssetType.value!.id,
      'plate': plateController.text.trim(),
      'nickname': nicknameController.text.trim(),
      'chassisNumber': chassisController.text.trim(),
      'color': _textOrNull(colorController),
      'manufacturingYear': _intOrNull(manufacturingYearController),
      'modelYear': _intOrNull(modelYearController),
      'invoice': _textOrNull(invoiceController),
      'costCenter': _textOrNull(costCenterController),
      'note': _textOrNull(noteController),
      'offlineThreshold': _intOrNull(offlineThresholdController),
      'offlineNotificationThreshold':
          _intOrNull(offlineNotificationThresholdController),
    };

    // Campos exclusivos do UpdateAssetRequest.
    if (isEditing) {
      payload.addAll({
        'engineType': engineTypeController.text.trim(),
        'engineSerialNumber': engineSerialNumberController.text.trim(),
        'additional1': _textOrNull(additional1Controller),
        'additional2': _textOrNull(additional2Controller),
        'additional3': _textOrNull(additional3Controller),
        'additional4': _textOrNull(additional4Controller),
      });
    }

    return payload;
  }

  String? _textOrNull(TextEditingController c) {
    final value = c.text.trim();
    return value.isEmpty ? null : value;
  }

  int? _intOrNull(TextEditingController c) => int.tryParse(c.text.trim());

  // --- Métodos expostos para os Autocompletes buscarem dados ---
  Future<List<CustomerEntity>> searchCustomers(String query) =>
      _repository.searchCustomers(query, 1);

  Future<List<ManufacturerEntity>> searchManufacturers(String query) =>
      _repository.getManufacturers();

  Future<List<AssetTypeEntity>> searchAssetTypes(String query) =>
      _repository.getAssetTypes();

  Future<List<ModelEntity>> searchModels(String query) {
    if (selectedManufacturer.value == null) return Future.value([]);
    return _repository.getModels(selectedManufacturer.value!.id, query);
  }

  @override
  void onClose() {
    for (final c in _allTextControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
