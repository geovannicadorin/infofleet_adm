import 'package:flutter/material.dart';

import 'selection_sheet.dart';

/// Select de seleção múltipla.
///
/// Exibe um campo no estilo do Design System que abre um bottom sheet com
/// checkboxes (com label visível) e permite escolher vários itens.
class AppMultiSelect<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final List<T> selectedItems;
  final Future<List<T>> Function(String query)? asyncItems;
  final List<T>? items;
  final void Function(List<T>)? onChanged;
  final String Function(T)? itemAsString;
  final bool showSearchBox;
  final bool Function(T a, T b)? compareFn;

  const AppMultiSelect({
    super.key,
    required this.label,
    this.hintText,
    this.selectedItems = const [],
    this.asyncItems,
    this.items,
    this.onChanged,
    this.itemAsString,
    this.showSearchBox = true,
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
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.secondary.withValues(alpha: 0.3);
    final isEmpty = selectedItems.isEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _openSheet(context),
      child: InputDecorator(
        isEmpty: isEmpty,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: theme.colorScheme.surface,
          suffixIcon: const Icon(Icons.arrow_drop_down),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
        child: isEmpty ? null : _buildChips(theme),
      ),
    );
  }

  Widget _buildChips(ThemeData theme) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: selectedItems.map((item) {
        return Chip(
          label: Text(_asString(item)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          onDeleted: () {
            final updated = selectedItems
                .where((e) => !_areEqual(e, item))
                .toList();
            onChanged?.call(updated);
          },
        );
      }).toList(),
    );
  }

  bool _areEqual(T a, T b) =>
      compareFn != null ? compareFn!(a, b) : a == b;

  Future<void> _openSheet(BuildContext context) async {
    final result = await showSelectionSheet<T>(
      context: context,
      title: label,
      fetch: _resolve,
      itemAsString: _asString,
      multiSelect: true,
      showSearch: showSearchBox,
      initialSelection: selectedItems,
      compareFn: compareFn,
    );

    if (result == null) return;
    onChanged?.call(result);
  }
}
