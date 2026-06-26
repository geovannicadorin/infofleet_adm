// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetDTO _$AssetDTOFromJson(Map<String, dynamic> json) => AssetDTO(
  id: json['id'] as String,
  manufacturerName: json['manufacturerName'] as String?,
  modelName: json['modelName'] as String?,
  plate: json['plate'] as String?,
  nickname: json['nickname'] as String?,
  chassisNumber: json['chassisNumber'] as String?,
  customerName: json['customerName'] as String?,
  ownerName: json['ownerName'] as String?,
  iconUrl: json['iconUrl'] as String?,
  lastConnectionTime: json['lastConnectionTime'] == null
      ? null
      : DateTime.parse(json['lastConnectionTime'] as String),
);

Map<String, dynamic> _$AssetDTOToJson(AssetDTO instance) => <String, dynamic>{
  'id': instance.id,
  'manufacturerName': instance.manufacturerName,
  'modelName': instance.modelName,
  'plate': instance.plate,
  'nickname': instance.nickname,
  'chassisNumber': instance.chassisNumber,
  'customerName': instance.customerName,
  'ownerName': instance.ownerName,
  'iconUrl': instance.iconUrl,
  'lastConnectionTime': instance.lastConnectionTime?.toIso8601String(),
};

AssetDetailsDTO _$AssetDetailsDTOFromJson(Map<String, dynamic> json) =>
    AssetDetailsDTO(
      id: json['id'] as String,
      customerId: json['customerId'] as String?,
      manufacturerId: json['manufacturerId'] as String?,
      modelId: json['modelId'] as String?,
      modelIdName: json['modelIdName'] as String?,
      assetType: (json['assetType'] as num?)?.toInt(),
      manufacturerName: json['manufacturerName'] as String?,
      modelName: json['modelName'] as String?,
      color: json['color'] as String?,
      manufacturingYear: json['manufacturingYear'],
      modelYear: json['modelYear'],
      plate: json['plate'] as String?,
      nickname: json['nickname'] as String?,
      chassisNumber: json['chassisNumber'] as String?,
      invoice: json['invoice'] as String?,
      costCenter: json['costCenter'] as String?,
      note: json['note'] as String?,
      ownerName: json['ownerName'] as String?,
      dealerName: json['dealerName'] as String?,
      iconUrl: json['iconUrl'] as String?,
      engineType: json['engineType'] as String?,
      engineSerialNumber: json['engineSerialNumber'] as String?,
      additional1: json['additional1'] as String?,
      additional2: json['additional2'] as String?,
      additional3: json['additional3'] as String?,
      additional4: json['additional4'] as String?,
      offlineThreshold: (json['offlineThreshold'] as num?)?.toInt(),
      offlineNotificationThreshold:
          (json['offlineNotificationThreshold'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AssetDetailsDTOToJson(AssetDetailsDTO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'manufacturerId': instance.manufacturerId,
      'modelId': instance.modelId,
      'modelIdName': instance.modelIdName,
      'assetType': instance.assetType,
      'manufacturerName': instance.manufacturerName,
      'modelName': instance.modelName,
      'color': instance.color,
      'manufacturingYear': instance.manufacturingYear,
      'modelYear': instance.modelYear,
      'plate': instance.plate,
      'nickname': instance.nickname,
      'chassisNumber': instance.chassisNumber,
      'invoice': instance.invoice,
      'costCenter': instance.costCenter,
      'note': instance.note,
      'ownerName': instance.ownerName,
      'dealerName': instance.dealerName,
      'iconUrl': instance.iconUrl,
      'engineType': instance.engineType,
      'engineSerialNumber': instance.engineSerialNumber,
      'additional1': instance.additional1,
      'additional2': instance.additional2,
      'additional3': instance.additional3,
      'additional4': instance.additional4,
      'offlineThreshold': instance.offlineThreshold,
      'offlineNotificationThreshold': instance.offlineNotificationThreshold,
    };
