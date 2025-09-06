import 'package:flutter/foundation.dart';
import '../../../properties/data/models/property.dart';
import '../../../properties/data/repositories/property_repository.dart';

class PropertyProvider extends ChangeNotifier {
  final PropertyRepository repo;
  PropertyProvider(this.repo);

  List<Property> _items = [];
  bool _loading = false;
  String _query = '';

  List<Property> get items => _items;
  bool get loading => _loading;
  String get query => _query;

  Future<void> load() async {
    _loading = true; notifyListeners();
    _items = await repo.getAll();
    _loading = false; notifyListeners();
  }

  Future<void> search(String q) async {
    _query = q;
    _loading = true; notifyListeners();
    _items = q.trim().isEmpty ? await repo.getAll() : await repo.search(q);
    _loading = false; notifyListeners();
  }

  Future<void> add(Property p) async {
    await repo.insert(p);
    await load();
  }

  Future<void> edit(Property p) async {
    await repo.update(p);
    await load();
  }

  Future<void> remove(int id) async {
    await repo.delete(id);
    await load();
  }
}
