import 'dart:io';
import 'package:flutter/material.dart';
import '../../../properties/data/models/property.dart';

class PropertyCard extends StatelessWidget {
  final Property item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const PropertyCard({super.key, required this.item, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildThumb(),
        title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(item.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildThumb() {
    if (item.imagePath == null || item.imagePath!.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.home));
    }
    final file = File(item.imagePath!);
    if (!file.existsSync()) {
      return const CircleAvatar(child: Icon(Icons.image_not_supported));
    }
    return CircleAvatar(backgroundImage: FileImage(file));
  }
}
