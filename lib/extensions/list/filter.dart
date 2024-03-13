extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) checkItem) =>
      map((items) => items.where((checkItem)).toList());
}
