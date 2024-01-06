<style>
.heading-1{
  font-size: 360%!important;
}
</style>

<h1 class="heading-1"><img align="center" height="50" src="https://github.com/igormidev/enchanted_collection/blob/master/art/logo_image.png?raw=true"> Enchanted collection toolkit</h1>

A collection of useful data structures and algorithms for collections.

### 🗂️ *Summary*
- [List util's](#list-utils)
  - [⦿ For each mapper](#for-each-mapper)
  - [⦿ Mapper](#mapper)
  - [⦿ Single where or null](#single-where-or-null)
  - [⦿ Insert in index](#insert-in-index)
  - [⦿ Change element in index](#change-element-in-index)
  - [⦿ Add value as last element of list](#add-value-as-last-element-of-list)
  - [⦿ Split into groups](#split-into-groups)
  - [⦿ Is any element diferent from null AND is any element null](#is-any-element-diferent-from-null-and-is-any-element-null)
  - [⦿ Remove null elements of a list](#remove-null-elements-of-a-list)
- [Map util's](#map-utils)
  - [⦿ Try cast map ( Return null if not possible )](#try-cast-map)
- [Cast functions](#cast-functions)
  - [⦿ Transform a list into a map ](#transform-a-list-into-a-map)
  - [⦿ Transform a list into a map with mapper](#transform-a-list-into-a-map-with-mapper)
  - [⦿ Transform a map into a list](#transform-a-map-into-a-list)
  - [⦿ Cast object/dynamic to desired type](#cast-objectdynamic-to-desired-type)

# List util's

## For each mapper
A for each function with aditional info in each interation.
Such as:
- Is the first interation? `isFirst`
- Is the last interation? `isLast`
- The index of the current interation `index`
- The value of the current interation `value`
```dart
final forEachMapperExample = [1, 2, 3];
forEachMapperExample.forEachMapper((value, isFirst, isLast, index) {
  print('value: $value');
  print('isFirst: $isFirst');
  print('isLast: $isLast');
  print('index: $index');
});
```

## Mapper
A map function with aditional info in each interation.

Such as:
- Is the first interation? `isFirst`
- Is the last interation? `isLast`
- The index of the current interation `index`
- The value of the current interation `value`

Returns a list of the mapped values.
```dart
final mapperExample = ['igor', 'miranda', 'souza'];
final List<Map<int, String>> mappedList = mapperExample.mapper((
  value,
  isFirst,
  isLast,
  index,
) {
  if (isFirst || isLast) {
    return {index: value.toUpperCase()};
  }
  return {index: value};
});
print(mappedList); // [{0: "IGOR"}, {1: "miranda"}, {2: "SOUZA"}]
```

## Single where or null
Equal to `singleWhere` but will not throw a error if element dosen't exist's. But will return `null` instead.
```dart
final List<int> singleWhereOrNullList = [1, 2, 3];
// Will return null:
print(singleWhereOrNullList.singleWhereOrNull((e) => e == 4));
// Will return 3:
print(singleWhereOrNullList.singleWhereOrNull((e) => e == 3));
```

## Insert in index
Will add [newValue] in the list in the position of [index].

Equal to [List.insert] function. But will return the list
itself with the added value. So you can cascade it.

```dart
final insertInIndexExample = [1, 2, 4];
insertInIndexExample.insertInIndex(1, 3);
print(insertInIndexExample); // [1, 2, 3, 4]
```

## Change element in index
Will change the value in the `index` position to `newValue`.

```dart
final changeListExample = [1, 2, 3];
changeListExample // cascade notation
    .changeAtIndexTo(0, 4)
    .changeAtIndexTo(1, 5)
    .changeAtIndexTo(2, 6);
print(changeListExample); // [4, 5, 6]
```

## Add value as last element of list
Will add [newValue] in the last position of the list.

Equal to [List.add] function. But will return the list
itself with the added value. So you can cascade it.
```dart
final addInLastExample = [1, 2, 3];
addInLastExample // cascade notation
    .addInLast(4)
    .addInLast(5)
    .addInLast(6);
print(addInLastExample); // [1, 2, 3, 4, 5, 6]
```

## Split into groups
Will split the list into groups of `quantityPerGroup` elements.

The last group may have less elements than `quantityPerGroup`.
```dart
final splitIntoGroupsExample = [1, 2, 3, 4, 5, 6, 7];
final List<List<int>> groups = splitIntoGroupsExample.splitIntoGroups(3);
print(groups); // [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7 ] ]
```

## Is any element diferent from null AND is any element null
```dart
final withNullList = [1, 2, 3, null];
final withoutNullList = [1, 2, 3];

print(withNullList.isAnyElementDiffFromNull); // true
print(withoutNullList.isAnyElementDiffFromNull); // true
```

## Remove null elements of a list
```dart
final withNullList = [1, 2, 3, null];
print(withNullList.removeNull); // [1, 2, 3]
```

# Integer util's
### bool isBiggerThen(int valueToBeCompared)
Will return true if the value is bigger then [valueToBeCompared].
### bool isBiggerOrEqualThen(int valueToBeCompared)
Will return true if the value is bigger or equal then [valueToBeCompared].
### bool isSmallerThen(int valueToBeCompared)
Will return true if the value is smaller then [valueToBeCompared].
### bool isSmallerOrEqualThen(int valueToBeCompared)
Will return true if the value is smaller or equal then [valueToBeCompared].

Example of thoose 4 compare functions:
```dart
final isBiggerThenTest = 4.isBiggerThen(6); // false
final isBiggerOrEqualThenTest = 4.isBiggerOrEqualThen(4); // true 
final isSmallerThenTest = 4.isSmallerThen(6); // true
final isSmallerOrEqualThenTest = 4.isSmallerOrEqualThen(4); // true
```

# Map util's

## Try cast map
Try to decode a json string into a map.
If the string is not a valid json, will return null.

Is just a boilerplate to avoid try/catch blocks.
Basically, this:
```dart
try {
  return jsonDecode(this);
} catch (_) {
  return null;
}
```
Example:
```dart
final String invalidJson = 'invalid json';
final String validJson = '{"name": "igor"}';
print(invalidJson.tryDecode); // null
print(validJson.tryDecode); // {"name": "igor"}
```

# Cast functions

## Transform a list into a map 
Will cast a list into a map.
For each element in the list, will call the `onElementToKey` and `onElementToValue` functions.

Example:
```dart
final list = [
  {
    'name': 'igor',
    'age': 23
  },
  {
    'name': 'miranda',
    'age': 30
  },
];
final Map<String, int> persons = list.castToMap(
  (element) {
    return element['name'] as String;
  },
  (element) {
    return element['age'] as int;
  },
);
```
`persons` map will be:
```json
{
  "igor": 23,
  "miranda": 30
}
``` 

## Transform a list into a map with mapper
Check [castToMap](#transform-a-list-into-a-map) documentation for base info about this function.
That because this function is basically a `castToMap` but
with more info in each interation, such as:
- Is the first interation? `isFirst`
- Is the last interation? `isLast`
- The index of the current interation `index`
- The value of the current interation `value`
```dart
```

## Transform a map into a list
For each Map entry, will map it to the return type with `toElementFunc` function and each return will be a element in the `List`.
```dart
final Map<String, int> personsMap = {
  "Igor": 23,
  "Miranda": 30,
};
final List<String> personsList = personsMap.castToList(
  (key, value) {
    return 'My name is $key, and I have $value years old.';
  },
);
print(personsList);
```

## Cast object/dynamic to desired type
Cast value to type [R].
Basically, a shortcut to `this as R`:
```dart
final dynamic dynamicList = 3;
final int intList = dynamicList.as<int>();
print(intList); // 3
```
---
Made with ❤ by [Igor Miranda](https://github.com/igormidev) <br>
If you like the package, give a 👍