import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/exceptions/app_exceptions.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/repositories/i_asset_repository.dart';

// Entidades auxiliares para os filtros (Assume-se que foram criadas no Domínio)
 import '../../domain/entities/customer_entity.dart';
 import '../../domain/entities/asset_type_entity.dart';
 import '../../domain/entities/work_status_entity.dart';
 import '../../domain/entities/manufacturer_entity.dart';  //Usado para AssetBrandId
 import '../../domain/entities/model_entity.dart';

class AssetListController extends GetxController {
  final IAssetRepository _repository;

  AssetListController(this._repository);

  // --- 1. CONFIGURAÇÃO DA PAGINAÇÃO ---
  static const int _pageSize = 10;
  final PagingController<int, AssetEntity> pagingController = 
        PagingController(firstPageKey: 1);

  // --- 2. ESTADO REATIVO: FILTROS E ORDENAÇÃO (Alinhado com a Model C#) ---
  final RxString searchQuery = ''.obs;                                 // Search
  final RxString ordinationField = 'id'.obs;                           // OrdinationField
  final RxString ordinationType = 'desc'.obs;                          // OrdinationType
  
  final Rx<CustomerEntity?> filterCustomer = Rx<CustomerEntity?>(null);       // CustomerId
  final Rx<AssetTypeEntity?> filterAssetType = Rx<AssetTypeEntity?>(null);    // AssetTypeId
  final RxList<WorkStatusEntity> filterStatuses = <WorkStatusEntity>[].obs;   // WorkStatusList
  
  final Rx<ManufacturerEntity?> filterBrand = Rx<ManufacturerEntity?>(null);  // AssetBrandId
  final Rx<ModelEntity?> filterModel = Rx<ModelEntity?>(null);                // AssetModelId
  
  final RxBool excludeGrouped = false.obs;                             // ExcludeGrouped
  final RxString filterGroup = ''.obs;                                 // AssetGroup (Assumindo string livre ou ID)

  @override
  void onInit() {
    super.onInit();
    
    // Escuta o Scroll: Quando chega ao fim da lista, pede a próxima página (pageKey)
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    // Debounce nativo do GetX para a barra de pesquisa:
    // Aguarda 500ms de inatividade do utilizador após digitar antes de chamar a API.
    // Isso economiza dezenas de requisições inúteis ao servidor.
    debounce(searchQuery, (_) {
      pagingController.refresh();
    }, time: const Duration(milliseconds: 500));
  }

  /// Busca os dados na API e alimenta o PagingController
  Future<void> _fetchPage(int pageKey) async {
    try {
      // O Repositório já foi ajustado para ignorar os campos nulos
      final result = await _repository.searchAssets(
        page: pageKey,
        perPage: _pageSize,
        search: searchQuery.value,
        ordinationField: ordinationField.value,
        ordinationType: ordinationType.value,
        customerId: filterCustomer.value?.id,
        assetTypeId: filterAssetType.value?.id,
        // O C# espera uma lista de strings. Extraímos apenas a propriedade 'name' (ex: "on", "off")
        workStatusList: filterStatuses.map((s) => s.name).toList(),
        assetBrandId: filterBrand.value?.id,
        assetModelId: filterModel.value?.id,
        excludeGrouped: excludeGrouped.value ? true : null,
        assetGroup: filterGroup.value.isNotEmpty ? filterGroup.value : null,
      );

      // Regra da Paginação Infinita
      final isLastPage = result.data.length < _pageSize;
      
      if (isLastPage) {
        pagingController.appendLastPage(result.data);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(result.data, nextPageKey);
      }
    } catch (error) {
      // Se ocorrer um erro (ex: sem internet), o PagingController lida com isso 
      // e exibe o nosso AppErrorState automaticamente na UI.
      pagingController.error = error;
    }
  }

  // --- 3. GESTÃO DO BOTTOM SHEET DE FILTROS ---

  /// Aplica os filtros selecionados no Bottom Sheet e recarrega a lista
  void applyFilters() {
    if (Get.isBottomSheetOpen == true) {
      Get.back(); // Fecha o Bottom Sheet suavemente
    }
    // Reinicia a paginação do zero (FirstPageKey = 1) com os novos filtros
    pagingController.refresh();
  }

  /// Limpa todos os filtros e recarrega a lista para o estado original
  void clearFilters() {
    filterCustomer.value = null;
    filterAssetType.value = null;
    filterStatuses.clear();
    filterBrand.value = null;
    filterModel.value = null;
    excludeGrouped.value = false;
    filterGroup.value = '';
    
    // Chamamos o apply para fechar o menu e dar refresh
    applyFilters();
  }

  /// Ação disparada pelo Swipe-to-Refresh nativo da tela principal
  Future<void> onRefresh() async {
    pagingController.refresh();
  }

  // --- 4. MÉTODOS DE APOIO PARA OS COMPONENTES DA UI (Autocompletes) ---
  
  Future<List<CustomerEntity>> searchCustomers(String query) {
    return _repository.searchCustomers(query, 1);
  }

  Future<List<AssetTypeEntity>> getAssetTypes(String query) {
    // Como a API de tipos devolve todos, a query é tratada no frontend pelo DropdownSearch
    return _repository.getAssetTypes();
  }

  Future<List<WorkStatusEntity>> getWorkStatuses(String query) {
    return _repository.getWorkStatuses();
  }

  Future<List<ManufacturerEntity>> searchBrands(String query) {
    return _repository.getManufacturers();
  }

  Future<List<ModelEntity>> searchModels(String query) {
    // Lógica inteligente: Se a marca (Brand) não estiver selecionada, não busca o modelo
    if (filterBrand.value == null) return Future.value([]);
    return _repository.getModels(filterBrand.value!.id, query);
  }

  // Lida com a dependência em cascata no menu de filtros
  void onBrandFilterChanged(ManufacturerEntity? brand) {
    filterBrand.value = brand;
    filterModel.value = null; // Reseta o modelo selecionado sempre que a marca mudar
  }

  @override
  void onClose() {
    // É obrigatório descartar o pagingController da memória ao sair da tela
    pagingController.dispose();
    super.onClose();
  }
}