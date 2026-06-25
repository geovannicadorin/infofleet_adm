import '../../../../shared/models/paginated_result.dart';
import '../entities/asset_entity.dart';
import '../entities/asset_type_entity.dart';
import '../entities/customer_entity.dart';
import '../entities/manufacturer_entity.dart';
import '../entities/model_entity.dart';
import '../entities/work_status_entity.dart';

abstract class IAssetRepository {
  Future<PaginatedResult<AssetEntity>> searchAssets({
    required int page,
    required int perPage,
    String? search,
    List<String>? workStatusList,
    String? customerId,         // Guid no C#
    String? ordinationField,
    String? ordinationType,
    int? assetTypeId,
    String? assetBrandId,       // Guid no C#
    String? assetModelId,       // Guid no C#
    bool? excludeGrouped,
    String? assetGroup,         // Guid no C#
  });

  // CRUD do Ativo
  Future<AssetEntity> getAssetDetails(String id);
  Future<void> createAsset(Map<String, dynamic> payload);
  Future<void> updateAsset(Map<String, dynamic> payload);

  // Autocompletes (Lookups)
  Future<List<CustomerEntity>> searchCustomers(String query, int page);
  Future<List<ManufacturerEntity>> getManufacturers();
  Future<List<ModelEntity>> getModels(String manufacturerId, String query);
  Future<List<AssetTypeEntity>> getAssetTypes();
  Future<List<WorkStatusEntity>> getWorkStatuses();
}