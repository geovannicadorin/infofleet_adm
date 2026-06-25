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
  final int? assetType;
  final String? manufacturerName;
  final String? modelName;
  final String? color;
  final dynamic manufacturingYear; // A API pode enviar como string ou int
  final String? plate;
  final String? nickname;
  final String? chassisNumber;
  final String? ownerName;
  final String? iconUrl;

  AssetDetailsDTO({
    required this.id,
    this.customerId,
    this.manufacturerId,
    this.modelId,
    this.assetType,
    this.manufacturerName,
    this.modelName,
    this.color,
    this.manufacturingYear,
    this.plate,
    this.nickname,
    this.chassisNumber,
    this.ownerName,
    this.iconUrl,
  });

  factory AssetDetailsDTO.fromJson(Map<String, dynamic> json) => _$AssetDetailsDTOFromJson(json);
}