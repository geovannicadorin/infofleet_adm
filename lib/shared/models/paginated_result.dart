/// Modelo genérico para encapsular respostas paginadas da API.
class PaginatedResult<T> {
  final List<T> data;
  final int length;
  final int totalItems;

  PaginatedResult({
    required this.data,
    required this.length,
    required this.totalItems,
  });
}