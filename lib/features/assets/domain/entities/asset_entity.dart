import 'package:equatable/equatable.dart';

/// Entidade de domínio que representa um Ativo dentro da aplicação.
/// Contém tanto os dados resumidos da listagem quanto os dados completos de edição.
class AssetEntity extends Equatable {
  final String id;
  final String plate;
  final String nickname;
  final String chassisNumber;
  final String manufacturerName;
  final String modelName;
  final String ownerName;
  final String? iconUrl;
  final DateTime? lastConnectionTime;

  // --- Campos adicionais para o Formulário de Edição ---
  final String? customerId;
  final String? manufacturerId;
  final String? modelId;

  /// Nome do modelo de catálogo (referenciado por [modelId]).
  final String? modelIdName;
  final int? assetType;
  final String? color;
  final int? manufacturingYear;
  final int? modelYear;
  final String? invoice;
  final String? costCenter;
  final String? note;
  final String? engineType;
  final String? engineSerialNumber;
  final String? additional1;
  final String? additional2;
  final String? additional3;
  final String? additional4;
  final int? offlineThreshold;
  final int? offlineNotificationThreshold;

  const AssetEntity({
    required this.id,
    required this.plate,
    required this.nickname,
    required this.chassisNumber,
    required this.manufacturerName,
    required this.modelName,
    required this.ownerName,
    this.iconUrl,
    this.lastConnectionTime,
    this.customerId,
    this.manufacturerId,
    this.modelId,
    this.modelIdName,
    this.assetType,
    this.color,
    this.manufacturingYear,
    this.modelYear,
    this.invoice,
    this.costCenter,
    this.note,
    this.engineType,
    this.engineSerialNumber,
    this.additional1,
    this.additional2,
    this.additional3,
    this.additional4,
    this.offlineThreshold,
    this.offlineNotificationThreshold,
  });

  // Regra de Negócio: Definição do Identificador Principal
  String get displayIdentifier {
    if (plate.isNotEmpty) return plate;
    if (nickname.isNotEmpty) return nickname;
    if (chassisNumber.isNotEmpty) return chassisNumber;
    return 'Sem identificação';
  }

  // Regra de Negócio: Iniciais para o Avatar
  String get avatarInitials {
    final identifier = displayIdentifier;
    if (identifier.length >= 2) return identifier.substring(0, 2).toUpperCase();
    if (identifier.isNotEmpty) return identifier.toUpperCase();
    return 'AT';
  }

  @override
  List<Object?> get props => [id, plate, nickname, chassisNumber];
}