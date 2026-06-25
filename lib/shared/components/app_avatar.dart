import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Componente de Avatar que mostra uma imagem em cache ou as iniciais.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallbackInitials;
  final double radius;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.fallbackInitials,
    this.radius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: radius,
          backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => _buildInitials(theme),
      );
    }

    return _buildInitials(theme);
  }

  Widget _buildInitials(ThemeData theme) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.primaryColor.withOpacity(0.1),
      child: Text(
        fallbackInitials.toUpperCase(),
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }
}