import 'package:lts_renovation_core/core.dart';
import 'package:lts_renovation_core/translation.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappeTranslationController frappeTranslationController;
  setUp(() async {
    await TestManager.getTestInstance();
    frappeTranslationController = getFrappeTranslationController();
  });

  group('Load Translation', () {
    test('should successfully load translations of the default language',
        () async {
      final response = await frappeTranslationController.loadTranslations();

      expect(response.isSuccess, true);
      expect(response.data, isA<Map>());
      expect(response.data.containsKey('TEST'), true);
    });

    test(
        'should successfully set the message dictionary after successfully loading the translation',
        () async {
      final response = await frappeTranslationController.loadTranslations();

      expect(response.isSuccess, true);
      expect(frappeTranslationController.getMessage(txt: 'TEST', lang: 'en'),
          isNotNull);
      expect(frappeTranslationController.getMessage(txt: 'TEST', lang: 'en'),
          'TRANSLATED TEST');
    });

    test('should successfully load translations of the Arabic language',
        () async {
      final response =
          await frappeTranslationController.loadTranslations(lang: 'ar');

      expect(response.isSuccess, true);
      expect(response.data, isA<Map>());
      expect(response.data.containsKey('TEST'), true);
      expect(response.data['TEST'], 'اختبار');
    });

    test(
        'should successfully load translations non-existing language with empty Map',
        () async {
      final response = await frappeTranslationController.loadTranslations(
          lang: 'non-existing');

      expect(response.isSuccess, true);
      expect(response.data.isEmpty, true);
    });
  });

  group('getMessage', () {
    test('should get the translation from the cached map', () async {
      await frappeTranslationController.loadTranslations();
      final message =
          frappeTranslationController.getMessage(txt: 'TEST', lang: 'en');
      expect(message, 'TRANSLATED TEST');
    });

    test('should return the txt as-is if the translation does not exist', () {
      final message = frappeTranslationController.getMessage(
          txt: 'NON-EXISTING', lang: 'en');
      expect(message, 'NON-EXISTING');
    });

    test('should return the txt as-is if the language does not exist', () {
      final message = frappeTranslationController.getMessage(
          txt: 'NON-EXISTING', lang: 'non-existing');
      expect(message, 'NON-EXISTING');
    });
  });

  group('setMessageDict', () {
    test('should set the dictionary successfully', () {
      frappeTranslationController
          .setMessagesDict(dict: {'TESTING': 'TRANSLATION'}, lang: 'en');

      expect(frappeTranslationController.getMessage(txt: 'TESTING'),
          'TRANSLATION');
    });
  });

  group('extendDictionary', () {
    test('should extend the existing map successfully', () {
      frappeTranslationController
          .extendDictionary(dict: {'TESTING-EXTENSION': 'TRANSLATION'});
      expect(frappeTranslationController.getMessage(txt: 'TESTING-EXTENSION'),
          'TRANSLATION');
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
