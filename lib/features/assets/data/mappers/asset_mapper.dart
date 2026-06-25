import '../../domain/entities/asset_entity.dart';
import '../models/asset_dto.dart';

class AssetMapper {
  AssetMapper._();

  /// Mapeia o DTO da Listagem para a Entidade de Domínio
  static AssetEntity fromListDTO(AssetDTO dto) {
    return AssetEntity(
      id: dto.id,
      plate: dto.plate ?? '',
      nickname: dto.nickname ?? '',
      chassisNumber: dto.chassisNumber ?? '',
      manufacturerName: dto.manufacturerName ?? 'Desconhecido',
      modelName: dto.modelName ?? 'Desconhecido',
      ownerName: dto.ownerName ?? dto.customerName ?? 'Sem proprietário',
      iconUrl: dto.iconUrl,
      lastConnectionTime: dto.lastConnectionTime,
    );
  }

  /// Mapeia o DTO de Detalhes para a Entidade de Domínio
  static AssetEntity fromDetailsDTO(AssetDetailsDTO dto) {

    // Tratamento de segurança para o ano de fabricação que pode vir como String ou Int
    int? parsedYear;
    if (dto.manufacturingYear != null) {
      if (dto.manufacturingYear is int) {
        parsedYear = dto.manufacturingYear;
      } else if (dto.manufacturingYear is String) {
        parsedYear = int.tryParse(dto.manufacturingYear);
      }
    }

    return AssetEntity(
      id: dto.id,
      plate: dto.plate ?? '',
      nickname: dto.nickname ?? '',
      chassisNumber: dto.chassisNumber ?? '',
      manufacturerName: dto.manufacturerName ?? 'Desconhecido',
      modelName: dto.modelName ?? 'Desconhecido',
      ownerName: dto.ownerName ?? 'Sem proprietário',
      iconUrl: dto.iconUrl,
      // Campos específicos do detalhe
      customerId: dto.customerId,
      manufacturerId: dto.manufacturerId,
      modelId: dto.modelId,
      assetType: dto.assetType,
      color: dto.color,
      manufacturingYear: parsedYear,
    );
  }
}