import 'package:renovation_core/auth.dart';
import 'package:renovation_core/backend.dart';
import 'package:renovation_core/core.dart';
import 'package:renovation_core/model.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  late FrappeLogManager log;
  final validUser = TestManager.primaryUser;
  final validPwd = TestManager.primaryUserPwd;

  setUpAll(() async {
    await TestManager.getTestInstance();
    log = getFrappeLogManager();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(validUser, validPwd);
  });

  group('Log Manager', () {
    group('Basic Log ', () {
      test('logging basic info', () async {
        var response = await log.info(content: 'Test Info 1');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Info');
        expect(logged?.content, 'Test Info 1');
      });
      test('logging info', () async {
        var response = await log.info(
            content: 'Test Info 2', tags: ['TAG1', 'TAG2'], title: 'TitleA');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Info');
        expect(logged?.content, 'Test Info 2');
        expect(logged?.title, 'TitleA');
        expect(logged?.tagsList?.contains('TAG1'), true);
        expect(logged?.tagsList?.contains('TAG2'), true);
      });
      test('failed logging basic info on empty content', () async {
        expect(() => log.info(content: ''),
            throwsA(TypeMatcher<EmptyContentError>()));
      });
    });

    group('Error Log', () {
      test('logging basic error', () async {
        var response = await log.error(content: 'Test error 1');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Error');
        expect(logged?.content, 'Test error 1');
      });
      test('logging error', () async {
        var response = await log.error(
            content: 'Test error 2', tags: ['TAG1', 'TAG2'], title: 'TitleA');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Error');
        expect(logged?.content, 'Test error 2');
        expect(logged?.title, 'TitleA');
        expect(logged?.tagsList?.contains('TAG1'), true);
        expect(logged?.tagsList?.contains('TAG2'), true);
      });
      test('failed logging basic error on empty content', () async {
        expect(() => log.error(content: ''),
            throwsA(TypeMatcher<EmptyContentError>()));
      });
    });

    group('Warning Log', () {
      test('logging basic warning', () async {
        var response = await log.warning(content: 'Test warning 1');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Warning');
        expect(logged?.content, 'Test warning 1');
      });
      test('logging warning', () async {
        var response = await log.warning(
            content: 'Test warning 2', tags: ['TAG1', 'TAG2'], title: 'TitleA');

        final logged = response.data;
        expect(response.isSuccess, true);
        expect(response.data, isA<FrappeLog>());
        expect(logged?.type, 'Warning');
        expect(logged?.content, 'Test warning 2');
        expect(logged?.title, 'TitleA');
        expect(logged?.tagsList?.contains('TAG1'), true);
        expect(logged?.tagsList?.contains('TAG2'), true);
      });
      test('failed logging basic warning on empty content', () async {
        expect(() => log.warning(content: ''),
            throwsA(TypeMatcher<EmptyContentError>()));
      });
    });

    group('Request Log', () {
      RequestResponse<User?>? response;
      setUpAll(() async {
        response = await getFrappeModelController().getDoc(User(), validUser);
      });

      test('Successful Request Log', () async {
        var r = await log.logRequest(r: response);
        expect(r.isSuccess, true);
        final logged = r.data;
        expect(logged?.type, 'Request');
        expect(logged?.request != null, true);
        expect(logged?.response != null, true);
      });
      test('Request Log on empty response', () async {
        expect(() => log.logRequest(r: response = null),
            throwsA(TypeMatcher<EmptyResponseError>()));
      });
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
