import 'package:renovation_core/model.dart';
import 'package:test/test.dart';

void main() {
  group('DBFilter', () {
    test('it should return true for type 1', () {
      final type1 = {'name': 'SOME NAME'};

      expect(DBFilter.isDBFilter(type1), true);
    });

    test('it should return true for type 2', () {
      final type2 = {
        'name': ['LIKE', 'SOME NAME']
      };

      expect(DBFilter.isDBFilter(type2), true);
    });

    test('it should return true for type 1 and type 2', () {
      final type1and2 = {
        'email': 'test@email.com',
        'name': ['LIKE', 'SOME NAME']
      };

      expect(DBFilter.isDBFilter(type1and2), true);
    });

    test('it should return true for type 3', () {
      final type3 = [
        ['name', 'LIKE', 'SOME NAME']
      ];

      expect(DBFilter.isDBFilter(type3), true);
    });

    test('it should return false for wrong type 1', () {
      final type1 = {1: 'test'};
      expect(DBFilter.isDBFilter(type1), false);
    });

    test('it should return false for wrong type 2', () {
      final type2 = {
        'name': ['LIKE', <dynamic, dynamic>{}]
      };
      expect(DBFilter.isDBFilter(type2), false);
    });

    test('it should return false for wrong type 1 and correct type 2', () {
      final type1and2 = {
        'name': ['LIKE', 'SOME NAME'],
        'email': <dynamic, dynamic>{},
      };
      expect(DBFilter.isDBFilter(type1and2), false);
    });

    test('it should return false for correct type 1 and wrong type 2', () {
      final type1and2 = {
        'name': ['', 'ABC'],
        'email': 'SOME NAME'
      };
      expect(DBFilter.isDBFilter(type1and2), false);
    });

    test('it should return false for wrong type 3', () {
      final type3 = [
        [1, 'LIKE', 'SOME NAME']
      ];
      expect(DBFilter.isDBFilter(type3), false);
    });

    test('it should return true where the value of type 2 is of type 2', () {
      final type2list = {
        'name': [
          'IN',
          ['TEST1', 'TEST2', 'TEST3']
        ]
      };
      expect(DBFilter.isDBFilter(type2list), true);
    });
  });
}
