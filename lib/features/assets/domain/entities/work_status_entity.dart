import 'package:equatable/equatable.dart';

class WorkStatusEntity extends Equatable {
  final int id;
  final String name;
  final String description;

  const WorkStatusEntity({required this.id, required this.name, required this.description});

  @override
  List<Object?> get props => [id, name];
}