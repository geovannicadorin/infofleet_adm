import 'package:equatable/equatable.dart';

class CustomerEntity extends Equatable {
  final String id;
  final String name;
  final String? document;
  final String? email;

  const CustomerEntity({
    required this.id,
    required this.name,
    this.document,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, document, email];
}