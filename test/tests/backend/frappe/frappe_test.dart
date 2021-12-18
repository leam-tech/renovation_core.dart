import 'package:renovation_core/backend.dart';
import 'package:renovation_core/core.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  Frappe? frappe;
  final validUser = TestManager.primaryUser;
  final validPwd = TestManager.primaryUserPwd;
  setUpAll(() async {
    await TestManager.getTestInstance();
    frappe = getFrappe();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(validUser, validPwd);
  });

  group('Frappe Versioning', () {
    test('should successfully load app version', () async {
      var response = await frappe!.loadAppVersions();
      expect(response.isSuccess, true);
      expect(response.data, true);
      expect(frappe!.allAppVersions, isA<List<AppVersion>>());
    });
  });

  group('FCM Notifications', () {
    test('should register fcm token', () async {
      var response = await frappe!.registerFCMToken('1234567890');
      expect(response.isSuccess, true);
      expect(response.data, 'OK');
    });
    test('should unregister fcm token', () async {
      var response = await frappe!.unregisterFCMToken('test');
      expect(response.isSuccess, true);
    });
    test('should get fcm notifications that are not seen', () async {
      var response = await frappe!.getFCMNotifications(seen: false);
      expect(response.isSuccess, true);
    });
    test('should get fcm notifications are seen', () async {
      var response = await frappe!.getFCMNotifications(seen: true);
      expect(response.isSuccess, true);
    });
    test('should mark fcm notification as seen', () async {
      //TODO:
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
