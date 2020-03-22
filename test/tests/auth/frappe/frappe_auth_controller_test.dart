import 'package:lts_renovation_core/auth.dart';
import 'package:lts_renovation_core/core.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  final skip = false;
  FrappeAuthController frappeAuthController;
  final mobileNo = '+971502760387';

  final validEmail = 'test@test.com';
  final validPwd = 'test@test';

  setUp(() async {
    await TestManager.getTestInstance();
    frappeAuthController = getFrappeAuthController();
  });

  group('login()', () {
    group('with Incorrect Credentials', () {
      test('should not login successfully with wrong credentials', () async {
        final response =
            await frappeAuthController.login(validEmail, 'wrong_password');

        expect(response.isSuccess, false);
        expect(response.httpCode, 401);
        expect(response.error.type, RenovationError.AuthenticationError);
        expect(response.error.info.cause, 'Incorrect password');
      }, skip: skip);

      test('should not login successfully for non-existing user', () async {
        final response =
            await frappeAuthController.login('test@test.net', validPwd);

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.type, RenovationError.NotFoundError);
        expect(response.error.info.cause, 'User disabled or missing');
      }, skip: skip);
    }, skip: skip);

    group('with Correct Credentials', () {
      test('should login successfully with correct credentials', () async {
        final response = await frappeAuthController.login(validEmail, validPwd);
        expect(response.isSuccess, true);
        expect(response.httpCode, 200);
        expect(frappeAuthController.isLoggedIn, true);
      }, skip: skip);

      test('should verify login status for test account as unauthorized',
          () async {
        final response = await frappeAuthController.checkLogin();
        expect(response.isSuccess, false);
        expect(frappeAuthController.isLoggedIn, false);
      });

      test('should verify login status for test account as authenticated',
          () async {
        await frappeAuthController.login(validEmail, validPwd);
        final response = await frappeAuthController.checkLogin();
        expect(response.isSuccess, true);
        expect(response.data.loggedIn, true);
      });
    });
  });

  group('pinLogin', () {
    test('should successfully login and set the session', () async {
      final response = await frappeAuthController.pinLogin(validEmail, '1234');

      expect(response.isSuccess, true);
      expect(response.data.currentUser, validEmail);
      expect(frappeAuthController.isLoggedIn, true);
    });

    test('should not successfully login for wrong pin', () async {
      final response = await frappeAuthController.pinLogin(validEmail, '0000');

      expect(response.isSuccess, false);
      expect(response.error.title, 'Incorrect Pin');
      expect(response.error.type, RenovationError.AuthenticationError);
      expect(response.error.info.httpCode, 401);
      expect(frappeAuthController.isLoggedIn, false);
    });
  });

  //TODO: Setup SMS Settings
  group('sendOTP', () {
    test('should fail sending SMS if the backend is not setup', () async {
      final response = await frappeAuthController.sendOTP(mobileNo);
      expect(response.isSuccess, false);
      expect(response.error.type, RenovationError.BackendSettingError);
      expect(response.error.title, 'SMS was not sent');
    });
  });

  group('verifyOTP', () {
    test('should verify OTP successfully without logging in', () async {
      //TODO:
    });
    test('should verify OTP successfully and log in', () async {
      //TODO:
    });
    test('should fail for invalid pin', () async {
      final response =
          await frappeAuthController.verifyOTP(mobileNo, '000000', false);
      expect(response.isSuccess, false);
      expect(response.data, isNull);
      expect(response.error.info.httpCode, 401);
      expect(response.error.type, RenovationError.AuthenticationError);
      expect(response.error.title, 'Wrong OTP');
    });
    test('should fail for non-existing user/mobile', () async {
      final response =
          await frappeAuthController.verifyOTP('+9710000000', '000000', false);
      expect(response.isSuccess, false);
      expect(response.data, isNull);
      expect(response.error.info.httpCode, 404);
      expect(response.error.type, RenovationError.NotFoundError);
      expect(response.error.title, 'User not found');
    });
    test('should successfully verify but not login an unlinked user', () async {
      //TODO:
    });
  });

  group('getCurrentUserRoles', () {
    test('should get the signed in user roles', () async {
      await frappeAuthController.login(validEmail, validPwd);
      final response = await frappeAuthController.getCurrentUserRoles();

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
    });
    test('should get exactly get "Guest" role if not signed in', () async {
      final response = await frappeAuthController.getCurrentUserRoles();

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.first, 'Guest');
    });
  });

  group('logout', () {
    test('should logout successfully', () async {
      await frappeAuthController.login(validEmail, validPwd);
      expect(frappeAuthController.isLoggedIn, true);
      await frappeAuthController.logout();
      expect(frappeAuthController.isLoggedIn, false);
    });
  });

  group('changeUserLanguage', () {
    test('should successfully change the language of current user', () async {
      await frappeAuthController.login(validEmail, validPwd);
      final response = await frappeAuthController.changeUserLanguage('ar');
      expect(response, true);
      expect(frappeAuthController.getSession().lang, 'ar');
    });
    test('should throw an Error if the user is not logged in', () async {
      expect(() async => await frappeAuthController.changeUserLanguage('ar'),
          throwsA(TypeMatcher<NotLoggedInUser>()));
    });
    test('should throw an Error if the language is incorrect', () async {
      expect(() async => await frappeAuthController.changeUserLanguage(''),
          throwsA(TypeMatcher<InvalidLanguage>()));
    });
  });

  group('clearAuthToken', () {
    test('should clearAuthToken successfully & remove Authorization headers',
        () async {
      await frappeAuthController.login(validEmail, validPwd);

      expect(frappeAuthController.getCurrentToken(), isNotNull);
      expect(
          RenovationRequestOptions.headers.containsKey('Authorization'), true);
      frappeAuthController.clearAuthToken();
      expect(frappeAuthController.getCurrentToken(), isNull);
      expect(
          RenovationRequestOptions.headers.containsKey('Authorization'), false);
    });
  });

  group('setAuthToken', () {
    test('should set the auth token successfully', () async {
      expect(frappeAuthController.getCurrentToken(), isNull);
      frappeAuthController.setAuthToken('TESTING TOKEN');
      expect(frappeAuthController.getCurrentToken(), isNotNull);
    });
  });

  group('resetSession', () {
    test('should reset the session to not logged in', () async {
      await frappeAuthController.login(validEmail, validPwd);
      expect(frappeAuthController.getSession().loggedIn, true);
      frappeAuthController.resetSession();
      expect(frappeAuthController.getSession().loggedIn, false);
    });
  });

  group('clearCache', () {
    test('should reset currentUserRoles on clearCache', () async {
      await frappeAuthController.login(validEmail, validPwd);
      await frappeAuthController.getCurrentUserRoles();
      expect(frappeAuthController.currentUserRoles.isNotEmpty, true);
      frappeAuthController.clearCache();
      expect(frappeAuthController.currentUserRoles.isNotEmpty, false);
    });
  });

  // Logout after every test
  tearDown(() => frappeAuthController.logout());
}
