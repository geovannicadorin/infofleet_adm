import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AppMultiSelect<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final List<T> selectedItems;
  final Future<List<T>> Function(String)? asyncItems;
  final void Function(List<T>)? onChanged;
  final String Function(T)? itemAsString;

  const AppMultiSelect({
    super.key,
    required this.label,
    this.hintText,
    this.selectedItems = const [],
    this.asyncItems,
    this.onChanged,
    this.itemAsString,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownSearch<T>.multiSelection(
      selectedItems: selectedItems,
      asyncItems: asyncItems,
      onChanged: onChanged,
      itemAsString: itemAsString,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      popupProps: PopupPropsMultiSelection.bottomSheet(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Pesquisar...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
    );
  }
}