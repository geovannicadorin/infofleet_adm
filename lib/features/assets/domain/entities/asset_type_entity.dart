import 'package:equatable/equatable.dart';

class AssetTypeEntity extends Equatable {
  final int id;
  final String name;

  const AssetTypeEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}