extension IterablesExtension<T> on Iterable<T> {
  Iterable<T> append(T other) => followedBy(Iterable.generate(1, (index) => other));

  /// Returns the element with the maximum value of [selector]
  /// If you want all elements with the maximum value, use [allMaxOf]
  R maxOf<R extends Comparable>(R Function(T element) selector) {
    assert(isNotEmpty);

    int compare(a, b) => selector(a).compareTo(selector(b));
    final sorted = [...this]..sort(compare);
    return selector(sorted.last);
  }

  /// Returns all elements with the maximum value of [selector]
  Iterable<T> allMaxOf<R extends Comparable>(R Function(T element) selector) {
    assert(isNotEmpty);

    int compare(T a, T b) => selector(a).compareTo(selector(b));
    final sorted = [...this]..sort(compare);
    final maximum = sorted.last;

    return where((element) => selector(element) == selector(maximum));
  }

  /// Returns the element with the minimum value of [selector]
  /// If you want all elements with the minimum value, use [allMinOf]
  R minOf<R extends Comparable>(R Function(T element) selector) {
    assert(isNotEmpty);

    int compare(a, b) => selector(a).compareTo(selector(b));
    final sorted = [...this]..sort(compare);
    return selector(sorted.first);
  }

  /// Returns all elements with the minimum value of [selector]
  Iterable<T> allMinOf<R extends Comparable>(R Function(T element) selector) {
    assert(isNotEmpty);
    int compare(a, b) => selector(a).compareTo(selector(b));
    final sorted = [...this]..sort(compare);

    final minimum = sorted.first;

    return where((element) => selector(element) == selector(minimum));
  }

  // T get max {
  //   assert(isNotEmpty);
  //   assert(T is Comparable<T>);
  //
  //   return sorted(
  //     (a, b) => (a as Comparable<T>).compareTo(b),
  //   ).last;
  // }
  //
  // T get min {
  //   assert(isNotEmpty);
  //   assert(T is Comparable<T>);
  //
  //   return sorted(
  //     (a, b) => (a as Comparable).compareTo(b),
  //   ).first;
  // }
}
