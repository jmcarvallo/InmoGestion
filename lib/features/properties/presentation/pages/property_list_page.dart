import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../properties/presentation/providers/property_provider.dart';
import '../../../properties/presentation/widgets/property_card.dart';
import '../../../properties/data/models/property.dart';
import '../../../auth/data/session_prefs.dart';

class PropertyListPage extends StatefulWidget {
  const PropertyListPage({super.key});

  @override
  State<PropertyListPage> createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ensureAuthAndLoad();
  }

  Future<void> _ensureAuthAndLoad() async {
    final logged = await SessionPrefs().isLoggedIn();
    if (!logged && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
      return;
    }
    if (mounted) context.read<PropertyProvider>().load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PropertyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inmuebles'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SessionPrefs().logout();
              if (!mounted) return;
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar por título o dirección...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          provider.search('');
                          setState(() {});
                        },
                      ),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (q) => provider.search(q),
            ),
          ),
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : provider.items.isEmpty
              ? const Center(child: Text('Sin inmuebles'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.items.length,
                  itemBuilder: (_, i) {
                    final item = provider.items[i];
                    return PropertyCard(
                      item: item,
                      onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
                      onEdit: () => Navigator.pushNamed(context, '/form', arguments: item),
                      onDelete: () => _confirmDelete(context, item),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/form'),
        icon: const Icon(Icons.add_home),
        label: const Text('Nuevo'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Property p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar inmueble'),
        content: Text('¿Deseas eliminar "${p.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<PropertyProvider>().remove(p.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inmueble eliminado')));
    }
  }
}
