import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage<T> {
  final SharedPreferencesAsync storage = SharedPreferencesAsync();

  String get key => runtimeType.toString();

  Future<T?> get();
  Future<void> set(T obj);
  Future<void> delete() async {
    return storage.remove(key);
  }
}
