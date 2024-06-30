class LocalDataBase {
  static Map<String, dynamic> _storage = {};

  void putData(dynamic key, dynamic value) {
    _storage[key.toString()] = value;
  }

  dynamic getData(dynamic key) {
    return _storage[key.toString()];
  }

  void deleteData(String key) {
    _storage.remove(key);
  }
}
