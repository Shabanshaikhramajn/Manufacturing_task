
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(int id);
  Future<int> add(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
}
