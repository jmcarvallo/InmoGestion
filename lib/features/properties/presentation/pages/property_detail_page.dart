import 'dart:io';
import 'package:flutter/material.dart';
import '../../../properties/data/models/property.dart';

class PropertyDetailPage extends StatelessWidget {
  final Property? item;
  const PropertyDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('No se recibió el inmueble a mostrar.')),
      );
    }
    final p = item!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del inmueble'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        // Si quieres permitir edición desde el detalle, descomenta:
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.edit),
        //     onPressed: () => Navigator.pushNamed(context, '/form', arguments: p),
        //   ),
        // ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Imagen grande 16:9 como en el form
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImage(p.imagePath),
            ),
          ),
          const SizedBox(height: 16),

          // Card de “formulario” (read-only)
          Card(
            elevation: 0,
            color: Colors.grey.shade300.withOpacity(0.30),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ReadOnlyField(
                    label: 'Título',
                    value: p.title,
                    icon: Icons.title,
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'Dirección',
                    value: p.address,
                    icon: Icons.place_outlined,
                  ),
                  const SizedBox(height: 12),
                  _ReadOnlyField(
                    label: 'Precio',
                    value: '\$${p.price.toStringAsFixed(2)}',
                    icon: Icons.attach_money,
                  ),
                  if ((p.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _ReadOnlyField(
                      label: 'Descripción',
                      value: p.description!,
                      icon: Icons.notes_outlined,
                      maxLines: 6,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        color: Colors.grey.shade300.withOpacity(0.30),
        child: const Center(child: Icon(Icons.home, size: 48, color: Colors.teal)),
      );
    }
    final f = File(path);
    if (!f.existsSync()) {
      return Container(
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image_not_supported, size: 48)),
      );
    }
    return Image.file(f, fit: BoxFit.cover);
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final int maxLines;

  const _ReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
    this.maxLines = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: theme.textTheme.labelMedium?.copyWith(color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            color: theme.colorScheme.surface,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            crossAxisAlignment: maxLines > 2
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value,
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
