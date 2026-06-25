import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'app_loading.dart';
import 'app_states.dart';

/// Wrapper genérico para PagedListView garantindo UX padronizada.
class AppPagination<T> extends StatelessWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;

  const AppPagination({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.emptyMessage = 'Nenhum registro encontrado.',
  });

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: itemBuilder,
        // Loading inicial
        firstPageProgressIndicatorBuilder: (_) => const AppLoading(size: 40),
        // Loading ao rolar para baixo
        newPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: AppLoading(),
        ),
        // Lista Vazia
        noItemsFoundIndicatorBuilder: (_) => AppEmptyState(message: emptyMessage),
        // Erro inicial
        firstPageErrorIndicatorBuilder: (_) => AppErrorState(
          errorMessage: pagingController.error?.toString() ?? 'Erro inesperado.',
          onRetry: () => pagingController.refresh(),
        ),
        // Erro ao carregar mais itens
        newPageErrorIndicatorBuilder: (_) => Padding(
          padding: EdgeInsets.all(16.0),
          child: AppErrorState(
            errorMessage: 'Erro ao carregar mais itens.',
            onRetry: () => pagingController.retryLastFailedRequest(),
          ),
        ),
      ),
    );
  }
}