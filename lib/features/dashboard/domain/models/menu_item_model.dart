import 'package:flutter/material.dart';

/// Modelo que representa um item clicável na Sidebar.
class MenuItemModel {
  final String title;
  final IconData icon;
  final String route;

  MenuItemModel({
    required this.title,
    required this.icon,
    required this.route,
  });
}