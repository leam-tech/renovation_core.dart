import 'package:renovation_core/auth.dart';
import 'package:renovation_core/core.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  final skip = false;
  late FrappeAuthController frappeAuthController;
  final mobileNo = TestManager.mobileNumber;

  final validUser = TestManager.secondaryUser;
  final validPwd = TestManager.secondaryUserPwd;
  final validPin = TestManager.getVariable(EnvVariables.PinNumber)!;

  setUp(() async {
    await TestManager.getTestInstance();
    frappeAuthController = getFrappeAuthController();
  });

  group('login()', () {
    group('with Incorrect Credentials', () {
      test('should not login successfully with wrong credentials', () async {
        final response =
            await frappeAuthController.login(validUser, 'wrong_password');

        expect(response.isSuccess, false);
        expect(response.httpCode, 401);
        expect(response.error!.type, RenovationError.AuthenticationError);
        expect(response.error!.info!.cause, 'Incorrect password');
      }, skip: skip);

      test('should not login successfully for non-existing user', () async {
        final response =
            await frappeAuthController.login('nonexisting@abc.com', validPwd);

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error!.type, RenovationError.NotFoundError);
        expect(response.error!.info!.cause, 'User disabled or missing');
      }, skip: skip);
    }, skip: skip);

    group('with Correct Credentials', () {
      test('should login successfully with correct credentials', () async {
        final response = await frappeAuthController.login(validUser, validPwd);
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
        await frappeAuthController.login(validUser, validPwd);
        final response = await frappeAuthController.checkLogin();
        expect(response.isSuccess, true);
        expect(response.data!.loggedIn, true);
      });
    });
  });

  group('estimatePassword()', () {
    group('Estimate password only', () {
      test('With score 0', () {
        final result = frappeAuthController.estimatePassword('1qaz2wsx3edc');
        expect(result.score, 0);
      }, skip: skip);

      test('With score 1', () {
        final result = frappeAuthController.estimatePassword('temppass22');
        expect(result.score, 1);
      }, skip: skip);

      test('With score 2', () {
        final result = frappeAuthController.estimatePassword('qwER43@!');
        expect(result.score, 2);
      }, skip: skip);

      test('With score 3', () {
        final result = frappeAuthController.estimatePassword('ryanhunter2000');
        expect(result.score, 3);
      }, skip: skip);

      test('With score 4', () {
        final result =
            frappeAuthController.estimatePassword('verlineVANDERMARK');
        expect(result.score, 4);
      }, skip: skip);
    }, skip: skip);
    group('Estimate password with custom inputs', () {
      test('With first name parameter', () {
        final result = frappeAuthController.estimatePassword('temppass22',
            firstName: 'temp');
        expect(result.score, 1);
      }, skip: skip);

      test('With email parameter', () {
        final result = frappeAuthController.estimatePassword('qwER43@!',
            email: 'er43@gmail.com');
        expect(result.score, 2);
      }, skip: skip);

      test('With last name parameter', () {
        final result = frappeAuthController.estimatePassword('ryanhunter2000',
            lastName: 'ryanhunter');
        expect(result.score, 1);
      }, skip: skip);

      test('With other inputs parameter', () {
        final result = frappeAuthController
            .estimatePassword('verlineVANDERMARK', otherInputs: ['VANDERMARK']);
        expect(result.score, 1);
      }, skip: skip);
    }, skip: skip);
  });

  group('pinLogin', () {
    test('should successfully login and set the session', () async {
      final response = await frappeAuthController.pinLogin(validUser, validPin);

      expect(response.isSuccess, true);
      expect(response.data!.currentUser, validUser);
      expect(frappeAuthController.isLoggedIn, true);
    });

    test('should not successfully login for wrong pin', () async {
      final response = await frappeAuthController.pinLogin(validUser, '0000');

      expect(response.isSuccess, false);
      expect(response.error!.title, 'Incorrect Pin');
      expect(response.error!.type, RenovationError.AuthenticationError);
      expect(response.error!.info!.httpCode, 401);
      expect(frappeAuthController.isLoggedIn, false);
    });
  });

  //TODO: Setup SMS Settings
  group('sendOTP', () {
    test('should fail sending SMS if the backend is not setup', () async {
      final response = await frappeAuthController.sendOTP(mobileNo);
      expect(response.isSuccess, false);
      expect(response.error!.type, RenovationError.BackendSettingError);
      expect(response.error!.title, 'SMS was not sent');
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
      expect(response.error!.info!.httpCode, 401);
      expect(response.error!.type, RenovationError.AuthenticationError);
      expect(response.error!.title, 'Wrong OTP');
    });
    test('should fail for non-existing user/mobile', () async {
      final response =
          await frappeAuthController.verifyOTP('+9710000000', '000000', false);
      expect(response.isSuccess, false);
      expect(response.data, isNull);
      expect(response.error!.info!.httpCode, 404);
      expect(response.error!.type, RenovationError.NotFoundError);
      expect(response.error!.title, 'User not found');
    });
    test('should successfully verify but not login an unlinked user', () async {
      //TODO:
    });
  });

  group('getCurrentUserRoles', () {
    test('should get the signed in user roles', () async {
      await frappeAuthController.login(validUser, validPwd);
      final response = await frappeAuthController.getCurrentUserRoles();

      expect(response?.isSuccess, true);
      expect(response?.data.isNotEmpty, true);
    });
    test('should get exactly get "Guest" role if not signed in', () async {
      final response = await frappeAuthController.getCurrentUserRoles();

      expect(response?.isSuccess, true);
      expect(response?.data.isNotEmpty, true);
      expect(response?.data.first, 'Guest');
    });
  });

  group('logout', () {
    test('should logout successfully', () async {
      await frappeAuthController.login(validUser, validPwd);
      expect(frappeAuthController.isLoggedIn, true);
      await frappeAuthController.logout();
      expect(frappeAuthController.isLoggedIn, false);
    });
  });

  group('changeUserLanguage', () {
    test('should successfully change the language of current user', () async {
      await frappeAuthController.login(validUser, validPwd);
      final response = await frappeAuthController.changeUserLanguage('ar');
      expect(response, true);
      expect(frappeAuthController.getSession()!.lang, 'ar');
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
      await frappeAuthController.login(validUser, validPwd);

      expect(frappeAuthController.getCurrentToken(), isNotNull);
      expect(
          RenovationRequestOptions.headers!.containsKey('Authorization'), true);
      frappeAuthController.clearAuthToken();
      expect(frappeAuthController.getCurrentToken(), isNull);
      expect(RenovationRequestOptions.headers!.containsKey('Authorization'),
          false);
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
      await frappeAuthController.login(validUser, validPwd);
      expect(frappeAuthController.getSession()!.loggedIn, true);
      frappeAuthController.resetSession();
      expect(frappeAuthController.getSession()!.loggedIn, false);
    });
  });

  group('clearCache', () {
    test('should reset currentUserRoles on clearCache', () async {
      await frappeAuthController.login(validUser, validPwd);
      await frappeAuthController.getCurrentUserRoles();
      expect(frappeAuthController.currentUserRoles!.isNotEmpty, true);
      frappeAuthController.clearCache();
      expect(frappeAuthController.currentUserRoles!.isNotEmpty, false);
    });
  });

  // Logout after every test
  tearDown(() => frappeAuthController.logout());
}
