import 'package:equatable/equatable.dart';

class ModelEntity extends Equatable {
  final String id;
  final String name;

  const ModelEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}