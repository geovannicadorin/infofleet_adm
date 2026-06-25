import '../../../../shared/models/paginated_result.dart';
import '../entities/asset_entity.dart';
import '../repositories/i_asset_repository.dart';

class SearchAssetsUseCase {
  final IAssetRepository _repository;

  SearchAssetsUseCase(this._repository);

  Future<PaginatedResult<AssetEntity>> call({
    required int page,
    required int perPage,
    String? search,
  }) {
    // Aqui poderíamos injetar regras de negócio antes de buscar,
    // como forçar um filtro específico de acordo com o perfil.
    return _repository.searchAssets(
      page: page,
      perPage: perPage,
      search: search,
    );
  }
}