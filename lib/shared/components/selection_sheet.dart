import 'dart:async';

import 'package:flutter/material.dart';

import 'app_button.dart';
import 'app_loading.dart';

/// Abre um seletor (single ou multi) em um bottom sheet com busca opcional.
///
/// Retorna a lista de itens escolhidos, ou `null` se o utilizador cancelar.
/// No modo single, a lista terá no máximo 1 item.
Future<List<T>?> showSelectionSheet<T>({
  required BuildContext context,
  required String title,
  required Future<List<T>> Function(String query) fetch,
  required String Function(T item) itemAsString,
  required bool multiSelect,
  bool showSearch = true,
  List<T> initialSelection = const [],
  bool Function(T a, T b)? compareFn,
}) {
  return showModalBottomSheet<List<T>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _SelectionSheet<T>(
      title: title,
      fetch: fetch,
      itemAsString: itemAsString,
      multiSelect: multiSelect,
      showSearch: showSearch,
      initialSelection: initialSelection,
      compareFn: compareFn,
    ),
  );
}

class _SelectionSheet<T> extends StatefulWidget {
  const _SelectionSheet({
    required this.title,
    required this.fetch,
    required this.itemAsString,
    required this.multiSelect,
    required this.showSearch,
    required this.initialSelection,
    this.compareFn,
  });

  final String title;
  final Future<List<T>> Function(String query) fetch;
  final String Function(T item) itemAsString;
  final bool multiSelect;
  final bool showSearch;
  final List<T> initialSelection;
  final bool Function(T a, T b)? compareFn;

  @override
  State<_SelectionSheet<T>> createState() => _SelectionSheetState<T>();
}

class _SelectionSheetState<T> extends State<_SelectionSheet<T>> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  bool _loading = true;
  Object? _error;
  List<T> _items = [];
  late List<T> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List<T>.from(widget.initialSelection);
    _load('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load(String query) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.fetch(query);
      if (!mounted) return;
      setState(() {
        _items = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _load(value));
  }

  bool _isSelected(T item) =>
      _selected.any((e) => _areEqual(e, item));

  bool _areEqual(T a, T b) =>
      widget.compareFn != null ? widget.compareFn!(a, b) : a == b;

  void _toggleMulti(T item) {
    setState(() {
      if (_isSelected(item)) {
        _selected.removeWhere((e) => _areEqual(e, item));
      } else {
        _selected.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        // Material (em vez de Container/BoxDecoration) garante o ancestral
        // necessário para o ListTile/CheckboxListTile renderizarem texto e ink.
        return Material(
          color: theme.scaffoldBackgroundColor,
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Column(
            children: [
              _buildHeader(theme),
              if (widget.showSearch) _buildSearchField(theme),
              Expanded(child: _buildBody(theme, scrollController)),
              if (widget.multiSelect) _buildFooter(theme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(widget.title, style: theme.textTheme.titleLarge),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: TextField(
        controller: _searchController,
        autofocus: false,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Pesquisar...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, ScrollController scrollController) {
    if (_loading) {
      return const AppLoading();
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline,
                  size: 40, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              const Text('Não foi possível carregar os dados.',
                  textAlign: TextAlign.center),
              const SizedBox(height: 12),
              AppButton(
                text: 'Tentar novamente',
                isOutlined: true,
                onPressed: () => _load(_searchController.text),
              ),
            ],
          ),
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Nenhum resultado encontrado.'),
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        final label = widget.itemAsString(item);
        final selected = _isSelected(item);

        if (widget.multiSelect) {
          return CheckboxListTile(
            value: selected,
            title: Text(label),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
            onChanged: (_) => _toggleMulti(item),
          );
        }

        return ListTile(
          title: Text(label),
          trailing: selected
              ? Icon(Icons.check, color: theme.colorScheme.primary)
              : null,
          dense: true,
          onTap: () => Navigator.of(context).pop(<T>[item]),
        );
      },
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Limpar',
                isOutlined: true,
                onPressed: () => setState(() => _selected.clear()),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppButton(
                text: 'Confirmar (${_selected.length})',
                onPressed: () => Navigator.of(context).pop(_selected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
