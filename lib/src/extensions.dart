import 'dart:async';
import 'dart:convert';

typedef Mapper<T, R> = R Function(
    T value, bool isFirst, bool isLast, int index);
typedef ForEachMapper<T> = FutureOr<void> Function(
    T value, bool isFirst, bool isLast, int index);

typedef CastToMapMapper<R, T> = R Function(
  T value,
  bool isFirst,
  bool isLast,
  int index,
);

/// {@template mapper}
/// A map function with aditional info in each interation.
///
/// Such as:
/// - Is the first interation? [isFirst]
/// - Is the last interation? [isLast]
/// - The index of the current interation [index]
/// - The value of the current interation [value]
///
/// Returns a list of the mapped values.
/// {@endtemplate}

/// {@template forEachMapper}
/// A for each function with aditional info in each interation.
/// Such as:
/// - Is the first interation? [isFirst]
/// - Is the last interation? [isLast]
/// - The index of the current interation [index]
/// - The value of the current interation [value]
/// {@endtemplate}

/// {@template singleWhereOrNull}
/// The single element satisfying [test].
///
/// Returns `null` if there are either no elements
/// or more than one element satisfying [test].
///
/// **Notice**: This behavior differs from [Iterable.singleWhere]
/// which always throws if there are more than one match,
/// and only calls the `orElse` function on zero matches.
/// {@endtemplate}

/// {@template splitIntoGroups}
/// Will split the list into groups of [quantityPerGroup] elements.
///
/// The last group may have less elements than [quantityPerGroup].
/// {@endtemplate}

/// {@template insertInIndex}
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
/// {@endtemplate}

/// {@template changeAtIndexTo}
/// Will change the value in the [index] position to [newValue].
/// {@endtemplate}

/// {@template addInLast}
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
/// {@endtemplate}

/// {@template castToMap}
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
/// {@endtemplate}

/// {@template castToMapWithMapper}
/// Check [castToMap] documentation for base info about this function.
/// That because this function is basically a [castToMap] but
/// with more info in each interation, such as:
/// - Is the first interation? [isFirst]
/// - Is the last interation? [isLast]
/// - The index of the current interation [index]
/// - The value of the current interation [value]
/// {@endtemplate}

/// {@template isAnyElementDiffFromNull}
/// Returns true if any element is different from null
/// {@endtemplate}

/// {@template isAnyElementNull}
/// Returns true if any element is null
/// {@endtemplate}

/// {@template removeNull}
/// Removes all null elements of a list
/// {@endtemplate}

/// Just to cast to list and do the default logic
extension IterableCastersToList<T> on Iterable<T> {
  /// {@macro mapper}
  List<R> mapper<R>(Mapper<T, R> toElement) => toList().mapper(toElement);

  /// {@macro forEachMapper}
  FutureOr<void> forEachMapper(ForEachMapper<T> toElement) =>
      toList().forEachMapper(toElement);

  /// {@macro singleWhereOrNull}
  T? singleWhereOrNull(bool Function(T element) test) =>
      toList().singleWhereOrNull(test);

  /// {@macro insertInIndex}
  List<T> insertInIndex(int index, T newValue) =>
      toList().insertInIndex(index, newValue);

  /// {@macro changeAtIndexTo}
  List<T> changeAtIndexTo(int index, T newValue) =>
      toList().changeAtIndexTo(index, newValue);

  /// {@macro addInLast}
  List<T> addInLast(T newValue) => toList().addInLast(newValue);

  /// {@macro splitIntoGroups}
  List<List<T>> splitIntoGroups(int quantityPerGroup) =>
      toList().splitIntoGroups(quantityPerGroup);

  /// {@macro castToMap}
  Map<K, V> castToMap<K, V>(
    K Function(T element) onElementToKey,
    V Function(T element) onElementToValue,
  ) =>
      toList().castToMap(onElementToKey, onElementToValue);

  /// {@macro castToMapWithMapper}
  Map<K, V> castToMapWithMapper<K, V>(
    CastToMapMapper<K, T> onElementToKey,
    CastToMapMapper<V, T> onElementToValue,
  ) =>
      toList().castToMapWithMapper(onElementToKey, onElementToValue);
}

/// A list of nullable elements.
extension NullableIterableLessBoilerPlateExtension<T> on Iterable<T?> {
  /// {@macro isAnyElementDiffFromNull}
  bool get isAnyElementDiffFromNull => toList().isAnyElementDiffFromNull;

  /// {@macro isAnyElementNull}
  bool get isAnyElementNull => toList().isAnyElementNull;

  /// {@macro removeNull}
  List<T> get removeNull => toList().removeNull;
}

extension ListUtils<T> on List<T> {
  /// {@macro mapper}
  List<R> mapper<R>(Mapper<T, R> toElement) {
    return asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      final isLast = (index + 1) == length;
      final isFirst = index == 0;
      return toElement(value, isFirst, isLast, index);
    }).toList();
  }

  /// {@macro forEachMapper}
  FutureOr<void> forEachMapper(ForEachMapper<T> toElement) async {
    asMap().entries.forEach((entry) async {
      final index = entry.key;
      final value = entry.value;
      final isLast = (index + 1) == length;
      final isFirst = index == 0;
      await toElement(value, isFirst, isLast, index);
    });
  }

  /// {@macro singleWhereOrNull}
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

  /// {@macro insertInIndex}
  List<T> insertInIndex(int index, T newValue) {
    insert(index, newValue);
    return this;
  }

  /// {@macro changeAtIndexTo}
  List<T> changeAtIndexTo(int index, T newValue) {
    this[index] = newValue;
    return this;
  }

  /// {@macro addInLast}
  List<T> addInLast(T newValue) {
    add(newValue);
    return this;
  }

  /// {@macro splitIntoGroups}
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
  /// {@macro isAnyElementDiffFromNull}
  bool get isAnyElementDiffFromNull => any((element) => element != null);

  /// {@macro isAnyElementNull}
  bool get isAnyElementNull => any((element) => element == null);

  /// {@macro removeNull}
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
  /// {@macro castToMap}
  Map<K, V> castToMap<K, V>(
    K Function(E element) onElementToKey,
    V Function(E element) onElementToValue,
  ) {
    return {for (var e in this) onElementToKey(e): onElementToValue(e)};
  }

  /// {@macro castToMapWithMapper}
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
