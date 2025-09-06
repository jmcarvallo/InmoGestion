import '../datasources/property_dao.dart';
import '../models/property.dart';

class PropertyRepository {
  final PropertyDao _dao;
  PropertyRepository(this._dao);

  Future<List<Property>> getAll() => _dao.getAll();
  Future<List<Property>> search(String q) => _dao.search(q);
  Future<Property?> getById(int id) => _dao.getById(id);
  Future<int> insert(Property p) => _dao.insert(p);
  Future<int> update(Property p) => _dao.update(p);
  Future<int> delete(int id) => _dao.delete(id);
}
