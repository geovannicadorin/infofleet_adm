import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// Componente genérico para Selects e Autocompletes.
/// Inspirado no vue-select e vue-autosuggest.
class AppAutocomplete<T> extends StatelessWidget {
  final String label;
  final String? hintText;
  final T? selectedItem;
  final List<T>? items; // Para buscas síncronas/locais (vue-select)
  final Future<List<T>> Function(String)? asyncItems; // Para buscas em API (vue-autosuggest)
  final void Function(T?)? onChanged;
  final String Function(T)? itemAsString;
  final bool showSearchBox;
  final String? Function(T?)? validator;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DropdownSearch<T>(
      selectedItem: selectedItem,
      items: items ?? [],
      asyncItems: asyncItems,
      onChanged: onChanged,
      itemAsString: itemAsString,
      validator: validator,
      // Configuração visual do campo fechado (parecido com o AppTextField)
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.3)),
          ),
        ),
      ),
      // Configuração do menu pop-up (lista de resultados)
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        searchDelay: const Duration(milliseconds: 500), // Debounce nativo para a API
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Pesquisar...",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        emptyBuilder: (context, searchEntry) => const Center(
          child: Text('Nenhum resultado encontrado.'),
        ),
      ),
    );
  }
}