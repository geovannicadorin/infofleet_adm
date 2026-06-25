import 'package:dio/dio.dart';
import '../../../../shared/models/paginated_result.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/asset_type_entity.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/entities/manufacturer_entity.dart';
import '../../domain/entities/model_entity.dart';
import '../../domain/entities/work_status_entity.dart';
import '../../domain/repositories/i_asset_repository.dart';
import '../mappers/asset_mapper.dart'; // Assume que já criaste
import '../models/asset_dto.dart'; // Assume que já criaste com json_serializable

class AssetRepositoryImpl implements IAssetRepository {
  final Dio _dio;

  AssetRepositoryImpl(this._dio);

  @override
  Future<PaginatedResult<AssetEntity>> searchAssets({
    required int page,
    required int perPage,
    String? search,
    List<String>? workStatusList,
    String? customerId,
    String? ordinationField,
    String? ordinationType,
    int? assetTypeId,
    String? assetBrandId,
    String? assetModelId,
    bool? excludeGrouped,
    String? assetGroup,
  }) async {
    
    // 1. Inicializa os campos obrigatórios
    final Map<String, dynamic> queryParams = {
      'Page': page,
      'PerPage': perPage,
    };

    // 2. Adiciona apenas os campos que não são nulos ou vazios (Clean Code)
    if (search != null && search.isNotEmpty) queryParams['Search'] = search;
    
    if (workStatusList != null && workStatusList.isNotEmpty) {
      // O Dio converte List<String> para o formato array da Query String automaticamente
      // Resultado na URL: &WorkStatusList=on&WorkStatusList=off
      queryParams['WorkStatusList'] = workStatusList; 
    }

    if (customerId != null && customerId.isNotEmpty) queryParams['CustomerId'] = customerId;
    if (ordinationField != null && ordinationField.isNotEmpty) queryParams['OrdinationField'] = ordinationField;
    if (ordinationType != null && ordinationType.isNotEmpty) queryParams['OrdinationType'] = ordinationType;
    if (assetTypeId != null) queryParams['AssetTypeId'] = assetTypeId;
    
    // Novos campos adicionados com base na Model C#
    if (assetBrandId != null && assetBrandId.isNotEmpty) queryParams['AssetBrandId'] = assetBrandId;
    if (assetModelId != null && assetModelId.isNotEmpty) queryParams['AssetModelId'] = assetModelId;
    if (excludeGrouped != null) queryParams['ExcludeGrouped'] = excludeGrouped;
    if (assetGroup != null && assetGroup.isNotEmpty) queryParams['AssetGroup'] = assetGroup;

    try {
      final response = await _dio.get('/api/v1/Asset/search', queryParameters: queryParams);

      final List<dynamic> dataList = response.data['data'] ?? [];
      final List<AssetEntity> assets = dataList.map((json) => AssetMapper.fromListDTO(AssetDTO.fromJson(json))).toList();

      return PaginatedResult<AssetEntity>(
        data: assets,
        length: response.data['length'] ?? 0,
        totalItems: response.data['totalItems'] ?? 0,
      );
    } on DioException catch (e) {
      throw Exception('Falha ao buscar ativos: ${e.message}');
    }
  }

  @override
  Future<AssetEntity> getAssetDetails(String id) async {
    final response = await _dio.get('/api/v1/Asset', queryParameters: {'id': id});
    // Assume que temos um DTO e Mapper completo para os detalhes
    return AssetMapper.fromDetailsDTO(AssetDetailsDTO.fromJson(response.data));
  }

  @override
  Future<void> createAsset(Map<String, dynamic> payload) async {
    await _dio.post('/api/v1/Asset', data: payload);
  }

  @override
  Future<void> updateAsset(Map<String, dynamic> payload) async {
    await _dio.put('/api/v1/Asset', data: payload);
  }

  // --- MÉTODOS PARA OS AUTOCOMPLETES ---
  @override
  Future<List<CustomerEntity>> searchCustomers(String query, int page) async {
    final response = await _dio.get(
      '/api/v1/Customer/search',
      queryParameters: {
        'Search': query,
        'CustomerTypes': [2, 3], // Regra exigida na documentação
        'Page': page,
        'PerPage': 20,
      },
    );
    // Mapeia a lista de clientes (Simplificado para o exemplo)
    return (response.data['data'] as List).map((c) => CustomerEntity(id: c['id'], name: c['name'])).toList();
  }

  @override
  Future<List<ManufacturerEntity>> getManufacturers() async {
    final response = await _dio.get('/api/v1/Asset/searchmanufacturer', queryParameters: {'Page': 1, 'PerPage': 100});
    return (response.data['data'] as List).map((m) => ManufacturerEntity(id: m['id'], name: m['name'])).toList();
  }

  @override
  Future<List<ModelEntity>> getModels(String manufacturerId, String query) async {
    final response = await _dio.get(
      '/api/v1/Asset/searchmodel', 
      queryParameters: {
        'ManufacturerId': manufacturerId,
        'Search': query,
        'Page': 1,
        'PerPage': 100,
      }
    );
    return (response.data['data'] as List).map((m) => ModelEntity(id: m['id'], name: m['name'])).toList();
  }

  @override
  Future<List<AssetTypeEntity>> getAssetTypes() async {
    final response = await _dio.get('/api/v1/Asset/searchtype');
    return (response.data['data'] as List)
        .map((json) => AssetTypeEntity(
      id: json['id'],
      name: json['name'],
    ))
        .toList();
  }

  @override
  Future<List<WorkStatusEntity>> getWorkStatuses() async {
    final response = await _dio.get('/api/v1/Asset/searchworkstatus');
    return (response.data['data'] as List)
        .map((json) => WorkStatusEntity(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
    ))
        .toList();
  }
}