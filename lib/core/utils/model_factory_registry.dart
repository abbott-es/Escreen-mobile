typedef FromJson<T> = T Function(Map<String, dynamic> json);

class ModelFactoryRegistry {
  ModelFactoryRegistry._();
  static final Map<Type, FromJson<dynamic>> _factories = {};

  static void register<T>(FromJson<T> factory) {
    _factories[T] = (json) => factory(json);
  }

  static T parse<T>(dynamic json) {
    final dynamicFactory = _factories[T];
    if (dynamicFactory == null) {
      throw StateError('No factory registered for type $T');
    }

    return dynamicFactory(json as Map<String, dynamic>) as T;
  }

  static bool has<T>() => _factories.containsKey(T);
}
