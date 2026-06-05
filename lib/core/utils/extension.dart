/// Extension on [List] for common utility operations.
extension IterableExtension<T> on List<T> {
  /// Returns a list with duplicates removed, based on a key selector.
  Iterable<T> distinctBy(String Function(T e) getCompareValue) {
    var idSet = <Object>{};
    var distinct = <T>[];
    for (var d in this) {
      if (idSet.add(getCompareValue(d))) {
        distinct.add(d);
      }
    }
    return distinct;
  }
}