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
    return AssetEntity(
      id: dto.id,
      plate: dto.plate ?? '',
      nickname: dto.nickname ?? '',
      chassisNumber: dto.chassisNumber ?? '',
      manufacturerName: dto.manufacturerName ?? 'Desconhecido',
      modelName: dto.modelName ?? '',
      ownerName: dto.ownerName ?? 'Sem proprietário',
      iconUrl: dto.iconUrl,
      // Campos específicos do detalhe
      customerId: dto.customerId,
      manufacturerId: dto.manufacturerId,
      modelId: dto.modelId,
      modelIdName: dto.modelIdName,
      assetType: dto.assetType,
      color: dto.color,
      manufacturingYear: _parseInt(dto.manufacturingYear),
      modelYear: _parseInt(dto.modelYear),
      invoice: dto.invoice,
      costCenter: dto.costCenter,
      note: dto.note,
      engineType: dto.engineType,
      engineSerialNumber: dto.engineSerialNumber,
      additional1: dto.additional1,
      additional2: dto.additional2,
      additional3: dto.additional3,
      additional4: dto.additional4,
      offlineThreshold: dto.offlineThreshold,
      offlineNotificationThreshold: dto.offlineNotificationThreshold,
    );
  }

  /// Converte um valor que a API pode enviar como int, String ou null.
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}