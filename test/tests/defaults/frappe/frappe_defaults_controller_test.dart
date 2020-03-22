import 'package:lts_renovation_core/auth.dart';
import 'package:lts_renovation_core/core.dart';
import 'package:lts_renovation_core/defaults.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappeDefaultsController frappeDefaultsController;
  setUpAll(() async {
    await TestManager.getTestInstance();
    frappeDefaultsController = getFrappeDefaultsController();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']);
    // To be used for getDefaults
    await frappeDefaultsController.setDefaults(
        key: 'testing_key', value: 'testing_value');
  });

  group('Get Defaults', () {
    test('should get defaults successfully', () async {
      final response =
          await frappeDefaultsController.getDefault(key: 'setup_complete');
      expect(response.isSuccess, true);
      expect(response.data != null, true);
      expect(response.data, isA<String>());
    });

    test("should get nothing if the key doesn't exist", () async {
      final response =
          await frappeDefaultsController.getDefault(key: 'non-existing-key');
      expect(response.isSuccess, true);
      expect(response.data, null);
    });
  });

  group('Set Defaults', () {
    test('should set a string value successfully', () async {
      final response = await frappeDefaultsController.setDefaults(
          key: 'testing_string_key', value: 'testing');
      expect(response.isSuccess, true);
    });

    test('should set a bool value successfully', () async {
      final response = await frappeDefaultsController.setDefaults(
          key: 'testing_bool_key', value: true);
      expect(response.isSuccess, true);
    });

    test('should set a num value successfully', () async {
      final response = await frappeDefaultsController.setDefaults(
          key: 'testing_num_key', value: 12345);
      expect(response.isSuccess, true);
    });

    test('should set a Map value successfully', () async {
      final response = await frappeDefaultsController.setDefaults(
          key: 'testing_map_key',
          value: <String, dynamic>{'testing_key': 'testing_value'});
      expect(response.isSuccess, true);
    });

    test('should set a List value successfully', () async {
      final response = await frappeDefaultsController
          .setDefaults(key: 'testing_list_key', value: <String>['testing']);
      expect(response.isSuccess, true);
    });

    test('should not set an invalid value', () async {
      expect(
          () async => await frappeDefaultsController.setDefaults(
              key: 'testing_invalid_key', value: User()),
          throwsA(TypeMatcher<InvalidDefaultsValue>()));
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
