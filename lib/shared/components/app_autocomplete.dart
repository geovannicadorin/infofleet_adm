import 'package:flutter/material.dart';

import 'selection_sheet.dart';

/// Select / Autocomplete de seleção única.
///
/// Exibe um campo no estilo do Design System que abre um bottom sheet com
/// busca (opcional) e lista de opções. Funciona tanto com listas locais
/// ([items]) quanto com busca assíncrona em API ([asyncItems]).
class AppAutocomplete<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final T? selectedItem;
  final List<T>? items;
  final Future<List<T>> Function(String query)? asyncItems;
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;

  /// Quando `false`, o campo se comporta como um Select clássico (sem busca).
  final bool showSearchBox;
  final String? Function(T?)? validator;
  final bool Function(T a, T b)? compareFn;

  const AppAutocomplete({
    super.key,
    required this.label,
    this.hintText,
    this.selectedItem,
    this.items,
    this.asyncItems,
    this.onChanged,
    this.itemAsString,
    this.showSearchBox = true,
    this.validator,
    this.compareFn,
  });

  String _asString(T item) => itemAsString?.call(item) ?? item.toString();

  Future<List<T>> _resolve(String query) async {
    if (asyncItems != null) return asyncItems!(query);
    final all = items ?? const [];
    if (query.isEmpty) return all;
    final lower = query.toLowerCase();
    return all.where((e) => _asString(e).toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: selectedItem,
      validator: validator,
      builder: (field) {
        final theme = Theme.of(context);
        final borderColor = theme.colorScheme.secondary.withValues(alpha: 0.3);

        // Mantém o estado do FormField alinhado ao valor controlado externamente.
        if (!_areEqual(field.value, selectedItem)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            field.didChange(selectedItem);
          });
        }

        return InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _openSheet(context, field),
          child: InputDecorator(
            isEmpty: selectedItem == null,
            decoration: InputDecoration(
              labelText: label,
              hintText: hintText,
              filled: true,
              fillColor: theme.colorScheme.surface,
              suffixIcon: const Icon(Icons.arrow_drop_down),
              errorText: field.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
            ),
            child: selectedItem == null
                ? null
                : Text(_asString(selectedItem as T),
                    style: theme.textTheme.bodyLarge),
          ),
        );
      },
    );
  }

  bool _areEqual(T? a, T? b) {
    if (a == null || b == null) return a == b;
    return compareFn != null ? compareFn!(a, b) : a == b;
  }

  Future<void> _openSheet(BuildContext context, FormFieldState<T> field) async {
    final result = await showSelectionSheet<T>(
      context: context,
      title: label,
      fetch: _resolve,
      itemAsString: _asString,
      multiSelect: false,
      showSearch: showSearchBox,
      initialSelection: selectedItem == null ? const [] : [selectedItem as T],
      compareFn: compareFn,
    );

    // null = cancelado; lista vazia não ocorre no modo single.
    if (result == null) return;
    final value = result.isEmpty ? null : result.first;
    field.didChange(value);
    onChanged?.call(value);
  }
}
