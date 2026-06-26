import 'package:json_annotation/json_annotation.dart';

part 'asset_dto.g.dart'; // Obrigatório para o build_runner

/// DTO para a resposta da Listagem de Ativos (/api/v1/Asset/search)
@JsonSerializable()
class AssetDTO {
  final String id;
  final String? manufacturerName;
  final String? modelName;
  final String? plate;
  final String? nickname;
  final String? chassisNumber;
  final String? customerName;
  final String? ownerName;
  final String? iconUrl;
  final DateTime? lastConnectionTime;

  AssetDTO({
    required this.id,
    this.manufacturerName,
    this.modelName,
    this.plate,
    this.nickname,
    this.chassisNumber,
    this.customerName,
    this.ownerName,
    this.iconUrl,
    this.lastConnectionTime,
  });

  factory AssetDTO.fromJson(Map<String, dynamic> json) => _$AssetDTOFromJson(json);
}

/// DTO para a resposta dos Detalhes do Ativo (/api/v1/Asset?id={id})
@JsonSerializable()
class AssetDetailsDTO {
  final String id;
  final String? customerId;
  final String? manufacturerId;
  final String? modelId;

  /// Nome do modelo de catálogo referenciado por [modelId].
  final String? modelIdName;

  final int? assetType;
  final String? manufacturerName;

  /// Nome do modelo em texto livre.
  final String? modelName;
  final String? color;
  final dynamic manufacturingYear; // A API pode enviar como string ou int
  final dynamic modelYear; // Idem
  final String? plate;
  final String? nickname;
  final String? chassisNumber;
  final String? invoice;
  final String? costCenter;
  final String? note;
  final String? ownerName;
  final String? dealerName;
  final String? iconUrl;
  final String? engineType;
  final String? engineSerialNumber;
  final String? additional1;
  final String? additional2;
  final String? additional3;
  final String? additional4;
  final int? offlineThreshold;
  final int? offlineNotificationThreshold;

  AssetDetailsDTO({
    required this.id,
    this.customerId,
    this.manufacturerId,
    this.modelId,
    this.modelIdName,
    this.assetType,
    this.manufacturerName,
    this.modelName,
    this.color,
    this.manufacturingYear,
    this.modelYear,
    this.plate,
    this.nickname,
    this.chassisNumber,
    this.invoice,
    this.costCenter,
    this.note,
    this.ownerName,
    this.dealerName,
    this.iconUrl,
    this.engineType,
    this.engineSerialNumber,
    this.additional1,
    this.additional2,
    this.additional3,
    this.additional4,
    this.offlineThreshold,
    this.offlineNotificationThreshold,
  });

  factory AssetDetailsDTO.fromJson(Map<String, dynamic> json) => _$AssetDetailsDTOFromJson(json);
}