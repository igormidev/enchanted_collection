import 'dart:convert';

typedef Mapper<T, R> = R Function(
    T value, bool isFirst, bool isLast, int index);
typedef ForEachMapper<T> = void Function(
    T value, bool isFirst, bool isLast, int index);

typedef CastToMapMapper<R, T> = R Function(
  T value,
  bool isFirst,
  bool isLast,
  int index,
);

extension ListUtils<T> on List<T> {
  /// A map function with aditional info in each interation.
  ///
  /// Such as:
  /// - Is the first interation? [isFirst]
  /// - Is the last interation? [isLast]
  /// - The index of the current interation [index]
  /// - The value of the current interation [value]
  ///
  /// Returns a list of the mapped values.
  List<R> mapper<R>(Mapper<T, R> toElement) {
    return asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final isLast = (index + 1) == length;
      final isFirst = index == 0;
      return toElement(value, isFirst, isLast, index);
    }).toList();
  }

  /// A for each function with aditional info in each interation.
  /// Such as:
  /// - Is the first interation? [isFirst]
  /// - Is the last interation? [isLast]
  /// - The index of the current interation [index]
  /// - The value of the current interation [value]
  void forEachMapper(ForEachMapper<T> toElement) {
    asMap().entries.forEach((entry) {
      final index = entry.key;
      final value = entry.value;
      final isLast = (index + 1) == length;
      final isFirst = index == 0;
      toElement(value, isFirst, isLast, index);
    });
  }

  /// The single element satisfying [test].
  ///
  /// Returns `null` if there are either no elements
  /// or more than one element satisfying [test].
  ///
  /// **Notice**: This behavior differs from [Iterable.singleWhere]
  /// which always throws if there are more than one match,
  /// and only calls the `orElse` function on zero matches.
  T? singleWhereOrNull(bool Function(T element) test) {
    T? result;
    var found = false;
    for (var element in this) {
      if (test(element)) {
        if (!found) {
          result = element;
          found = true;
        } else {
          return null;
        }
      }
    }
    return result;
  }

  /// Will add [newValue] in the list in the position of [index].
  ///
  /// Equal to [List.insert] function. But will return the list
  /// itself with the added value. So you can cascade it.
  ///
  /// Example:
  /// ```dart
  /// final insertInIndexExample = [1, 2, 4];
  /// insertInIndexExample.insertInIndex(1, 3);
  /// print(insertInIndexExample); // [1, 2, 3, 4]
  /// ```
  List<T> insertInIndex(int index, T newValue) {
    insert(index, newValue);
    return this;
  }

  /// Will change the value in the [index] position to [newValue].
  List<T> changeAtIndexTo(int index, T newValue) {
    this[index] = newValue;
    return this;
  }

  /// Will add [newValue] in the last position of the list.
  ///
  /// Equal to [List.add] function. But will return the list
  /// itself with the added value. So you can cascade it.
  ///
  /// Example:
  /// ```dart
  /// final list = [1, 2, 3];
  /// list
  ///   .addInLast(4)
  ///   .addInLast(5)
  ///   .addInLast(6);
  /// ```
  List<T> addInLast(T newValue) {
    add(newValue);
    return this;
  }

  /// Will split the list into groups of [quantityPerGroup] elements.
  ///
  /// The last group may have less elements than [quantityPerGroup].
  List<List<T>> splitIntoGroups(int quantityPerGroup) {
    final List<List<T>> val = [];
    if (quantityPerGroup == 1) {
      for (final element in this) {
        val.add([element]);
      }
      return val;
    }

    List<T> acummulator = [];
    int count = 0;
    for (final element in this) {
      if (count >= quantityPerGroup) {
        count = 0;
        val.add(acummulator);
        acummulator = [element];
      } else {
        acummulator.add(element);
      }
      count++;
    }
    if (acummulator.isNotEmpty) {
      val.add(acummulator);
    }

    return val;
  }
}

/// A list of nullable elements.
extension NullableListLessBoilerPlateExtension<T> on List<T?> {
  /// Returns true if any element is different from null
  bool get isAnyElementDiffFromNull => any((element) => element != null);

  /// Returns true if any element is null
  bool get isAnyElementNull => any((element) => element == null);

  /// Returns all null elements of a list
  List<T> get removeNull => whereType<T>().toList();
}

extension MapCaster<K, V> on Map<K, V> {
  /// For each Map entry, will map it to type
  /// [E] with [toElementFunc] function and each
  /// return will be a element in the [List].
  List<E> castToList<E>(
    E Function(K key, V value) toElementFunc,
  ) =>
      entries.map((entry) => toElementFunc(entry.key, entry.value)).toList();
}

extension ListCasters<E> on List<E> {
  /// Will cast a list into a map.
  ///
  /// For each element in the list, will call the [onElementToKey] and [onElementToValue] functions.
  ///
  /// Example:
  /// ```dart
  /// final list = [
  ///   {
  ///     'name': 'igor',
  ///     'age': 23
  ///   },
  ///   {
  ///     'name': 'miranda',
  ///     'age': 30
  ///   },
  /// ];
  /// final Map<String, int> persons = list.castToMap(
  ///   (element) {
  ///     return element['name'] as String;
  ///   },
  ///   (element) {
  ///     return element['age'] as int;
  ///   },
  /// );
  /// ```
  /// `persons` map will be:
  /// ```json
  /// {
  ///   "igor": 23,
  ///   "miranda": 30
  /// }
  /// ```
  Map<K, V> castToMap<K, V>(
    K Function(E element) onElementToKey,
    V Function(E element) onElementToValue,
  ) {
    return {for (var e in this) onElementToKey(e): onElementToValue(e)};
  }

  /// Check [castToMap] documentation for base info about this function.
  /// That because this function is basically a [castToMap] but
  /// with more info in each interation, such as:
  /// - Is the first interation? [isFirst]
  /// - Is the last interation? [isLast]
  /// - The index of the current interation [index]
  /// - The value of the current interation [value]
  Map<K, V> castToMapWithMapper<K, V>(
    CastToMapMapper<K, E> onElementToKey,
    CastToMapMapper<V, E> onElementToValue,
  ) {
    return Map.fromEntries(
      mapper((value, isFirst, isLast, index) {
        return MapEntry(
          onElementToKey(value, isFirst, isLast, index),
          onElementToValue(value, isFirst, isLast, index),
        );
      }),
    );
  }
}

extension GenericsExtension<T> on T {
  /// Cast value to type [R].
  /// Basically, a shortcut to `this as R`:
  R as<R>() => this as R;
}

extension StringExtension on String {
  /// Try to decode a json string into a map.
  /// If the string is not a valid json, will return null.
  ///
  /// Is just a boilerplate to avoid try/catch blocks.
  /// Basically, this:
  /// ```dart
  /// try {
  ///   return jsonDecode(this);
  /// } catch (_) {
  ///   return null;
  /// }
  /// ```
  Map? get tryDecode {
    try {
      return jsonDecode(this);
    } catch (_) {
      return null;
    }
  }
}
