import 'package:enchanted_collection/enchanted_collection.dart';

void main() {
  // ╔════════╗
  // ║ Mapper ║
  // ╚════════╝
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

  // ╔═════════════════╗
  // ║ For each mapper ║
  // ╚═════════════════╝
  final forEachMapperExample = [1, 2, 3];
  forEachMapperExample.forEachMapper((value, isFirst, isLast, index) {
    print('value: $value');
    print('isFirst: $isFirst');
    print('isLast: $isLast');
    print('index: $index');
  });

  // ╔══════════════════════╗
  // ║ Single where or null ║
  // ╚══════════════════════╝
  final List<int> singleWhereOrNullList = [1, 2, 3];
  // Will return null:
  print(singleWhereOrNullList.singleWhereOrNull((e) => e == 4));
  // Will return 3:
  print(singleWhereOrNullList.singleWhereOrNull((e) => e == 3));

  // ╔═════════════════╗
  // ║ Insert in index ║
  // ╚═════════════════╝
  final insertInIndexExample = [1, 2, 4];
  insertInIndexExample.insertInIndex(1, 3);
  print(insertInIndexExample); // [1, 2, 3, 4]

  // ╔═════════════════════════╗
  // ║ Change element in index ║
  // ╚═════════════════════════╝
  final changeListExample = [1, 2, 3];
  changeListExample // cascade notation
      .changeAtIndexTo(0, 4)
      .changeAtIndexTo(1, 5)
      .changeAtIndexTo(2, 6);
  print(changeListExample); // [4, 5, 6]

  // ╔═══════════════════════════════════╗
  // ║ Add value as last element of list ║
  // ╚═══════════════════════════════════╝
  final addInLastExample = [1, 2, 3];
  addInLastExample // cascade notation
      .addInLast(4)
      .addInLast(5)
      .addInLast(6);
  print(addInLastExample); // [1, 2, 3, 4, 5, 6]

  // ╔═══════════════════╗
  // ║ Split into groups ║
  // ╚═══════════════════╝
  final splitIntoGroupsExample = [1, 2, 3, 4, 5, 6, 7];
  final List<List<int>> groups = splitIntoGroupsExample.splitIntoGroups(3);
  print(groups); // [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7 ] ]

  // ╔═══════════════════════════════════╗
  // ║ Is any element diferent from null ║
  // ║ AND is any element null.          ║
  // ╚═══════════════════════════════════╝
  final withNullList = [1, 2, 3, null];
  final withoutNullList = [1, 2, 3];

  print(withNullList.isAnyElementDiffFromNull); // true
  print(withoutNullList.isAnyElementDiffFromNull); // true

  // ╔══════════════════════╗
  // ║ Remove null elements ║
  // ╚══════════════════════╝
  print(withNullList.removeNull); // [1, 2, 3]

  // ╔══════════════════════╗
  // ║ Cast list to map     ║
  // ╚══════════════════════╝
  final list = [
    {'name': 'igor', 'age': 23},
    {'name': 'miranda', 'age': 30},
  ];
  final Map<String, int> persons = list.castToMap(
    (element) {
      return element['name'] as String;
    },
    (element) {
      return element['age'] as int;
    },
  );
  print(persons); // persons map will be:
  // {
  //   "igor": 23,
  //   "miranda": 30
  // }

  // ╔══════════════════════╗
  // ║ Cast map to list     ║
  // ╚══════════════════════╝
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

  // ╔══════════════════╗
  // ║ Try decoding map ║
  // ╚══════════════════╝
  final String invalidJson = 'invalid json';
  final String validJson = '{"name": "igor"}';
  print(invalidJson.tryDecode); // null
  print(validJson.tryDecode); // {"name": "igor"}

  // ╔═══════════════════╗
  // ║ Cast with as<T>() ║
  // ╚═══════════════════╝
  final dynamic dynamicList = 3;
  final int intList = dynamicList.castTo<int>();
  print(intList); // 3

  final isBiggerThenTest = 4.isBiggerThen(6); // false
  final isBiggerOrEqualThenTest = 4.isBiggerOrEqualThen(4); // true
  final isSmallerThenTest = 4.isSmallerThen(6); // true
  final isSmallerOrEqualThenTest = 4.isSmallerOrEqualThen(4); // true

  print(isBiggerThenTest);
  print(isBiggerOrEqualThenTest);
  print(isSmallerThenTest);
  print(isSmallerOrEqualThenTest);
}
