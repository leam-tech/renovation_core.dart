import 'package:renovation_core/auth.dart';
import 'package:renovation_core/core.dart';
import 'package:renovation_core/perm.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappePermissionController frappePermissionController;
  FrappeAuthController frappeAuthController;

  final testEmail = '<username>';
  final testPwd = '<password>';

  setUp(() async {
    await TestManager.getTestInstance();
    frappePermissionController = getFrappePermissionController();
    frappeAuthController = getFrappeAuthController();
    // Login the user to have permission to get the document
    await frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']);
  });

  group('Load Basic Permission', () {
    test(
        'should successfully load basic permissions of <admin_user> from the backend',
        () async {
      final response = await frappePermissionController.loadBasicPerms();

      expect(response.isSuccess, true);
      expect(response.data.can_read.isNotEmpty, true);
      expect(frappePermissionController.basicPerms, isNotNull);
    });

    test('should successfully load basic permissions of <password>', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.loadBasicPerms();

      expect(response.isSuccess, true);
      expect(response.data.can_set_user_permissions.isEmpty, true);
    });

    //TODO: Check fail cases

    // Re-login to <admin_user> for the rest of the tests.
    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('Get Permissions of a doctype', () {
    test(
        'should get the list of permissions of a doctype successfully for <admin_user>',
        () async {
      final response =
          await frappePermissionController.getPerm(doctype: 'User');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.first.ifOwner, false);
      expect(response.data.first.create, true);
      expect(response.data.first.submit, false);
      expect(response.data.first.permLevel, 0);
      expect(response.data.last.permLevel, 1);
    });

    test(
        'should get the list of permissions of a doctype successfully for <username>',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.getPerm(doctype: 'User');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.first.ifOwner, false);
      expect(response.data.first.write, true);
      expect(response.data.first.create, false);
      expect(response.data.first.permLevel, 0);
    });

    test(
        'should return a single DocPerm with three field predefined if the doctype does not exist',
        () async {
      // To reset the stored permissions
      Renovation().clearCache();

      final response =
          await frappePermissionController.getPerm(doctype: 'NON EXISTING');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.length, 1);
      expect(response.data.first.read, isNotNull);
      expect(response.data.first.permLevel, 0);
      expect(response.data.first.ifOwner, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('hasPerm', () {
    test('should return true for <admin_user> to create User', () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User', pType: PermissionType.create);

      expect(response, true);
    });

    test('should return false for <admin_user> to submit User', () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User', pType: PermissionType.submit);

      expect(response, false);
    });

    test('should return true for <admin_user> to write User with permLevel 1',
        () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User', pType: PermissionType.write, permLevel: 1);

      expect(response, true);
    });

    test(
        'should return false for <admin_user> to create User with permLevel 1',
        () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User', pType: PermissionType.create, permLevel: 1);

      expect(response, false);
    });

    test('should return false for non existin permLevel', () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User', pType: PermissionType.read, permLevel: 2);

      expect(response, false);
    });

    test('should return false for non existin doctype', () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'NON EXISTING', pType: PermissionType.read, permLevel: 2);

      expect(response, false);
    });

    test('should return true for create <admin_user> of a specific doctype',
        () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User',
          docname: '<admin_user>',
          pType: PermissionType.create);

      expect(response, true);
    });

    test('should return false for submit <admin_user> of a specific doctype',
        () async {
      final response = await frappePermissionController.hasPerm(
          doctype: 'User',
          docname: '<admin_user>',
          pType: PermissionType.submit);

      expect(response, false);
    });

    test('should throw InvalidPermissionLevel if permLevel not between 0-9',
        () async {
      expect(
          () async => await frappePermissionController.hasPerm(
              doctype: 'User', pType: PermissionType.read, permLevel: 10),
          throwsA(TypeMatcher<InvalidPermissionLevel>()));
    });
  });

  group('hasPerms', () {
    test('should return true for <admin_user> to create, read and write User',
        () async {
      final response = await frappePermissionController.hasPerms(
          doctype: 'User',
          pTypes: [
            PermissionType.create,
            PermissionType.read,
            PermissionType.write
          ]);

      expect(response, true);
    });

    test(
        'should return false for create, submit, read and write <admin_user> of a specific doctype',
        () async {
      final response =
          await frappePermissionController.hasPerms(doctype: 'User', pTypes: [
        PermissionType.create,
        PermissionType.submit,
        PermissionType.read,
        PermissionType.write
      ]);

      expect(response, false);
    });
  });

  group('canRead', () {
    test('should return true for <admin_user> read on System Settings',
        () async {
      final response =
          await frappePermissionController.canRead('System Settings');

      expect(response, true);
    });

    test('should return false for <username> read on System Settings',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.canRead('System Settings');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canCreate', () {
    test('should return true for <admin_user> create on User', () async {
      final response = await frappePermissionController.canCreate('User');

      expect(response, true);
    });

    test('should return false for <username> create on Use', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canCreate('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canWrite', () {
    test('should return true for <admin_user> write on System Settings',
        () async {
      final response =
          await frappePermissionController.canWrite('System Settings');

      expect(response, true);
    });

    test('should return false for <username> create on System Settings',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.canWrite('System Settings');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canCancel', () {
    test('should return true for <admin_user> cancel on Sales Invoice',
        () async {
      final response =
          await frappePermissionController.canCancel('Sales Invoice');

      expect(response, true);
    });

    test('should return false for <username> create on Sales Invoice',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.canCancel('Sales Invoice');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canDelete', () {
    test('should return true for <admin_user> delete on User', () async {
      final response = await frappePermissionController.canDelete('User');

      expect(response, true);
    });

    test('should return false for <username> delete on User', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canDelete('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canImport', () {
    test('should return true for <admin_user> import on User', () async {
      final response = await frappePermissionController.canImport('User');

      expect(response, true);
    });

    test('should return false for <username> import on User', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canImport('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canExport', () {
    test('should return true for <admin_user> export on Item Group', () async {
      final response = await frappePermissionController.canExport('Item Group');

      expect(response, true);
    });

    test('should return false for <username> export on Item Group',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canExport('Item Group');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canPrint', () {
    test('should return true for <admin_user> print on Sales Invoice',
        () async {
      final response =
          await frappePermissionController.canPrint('Sales Invoice');

      expect(response, true);
    });

    test('should return false for <username> print on Sales Invoice',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.canPrint('Sales Invoice');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canEmail', () {
    test('should return true for <admin_user> email on User', () async {
      final response = await frappePermissionController.canEmail('User');

      expect(response, true);
    });

    test('should return false for <username> print on User', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canEmail('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canSearch', () {
    test('should return true for <admin_user> search on Bank', () async {
      final response = await frappePermissionController.canSearch('Bank');

      expect(response, true);
    });

    test('should return false for <username> search on Bank', () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController.canSearch('Bank');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canGetReport', () {
    test(
        'should return true for <admin_user> get report on Renovation User Agreement',
        () async {
      final response = await frappePermissionController
          .canGetReport('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for <username> get report on Renovation User Agreement',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response = await frappePermissionController
          .canGetReport('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canSetUserPermission', () {
    test(
        'should return false for <admin_user> setting user permission on User',
        () async {
      final response =
          await frappePermissionController.canSetUserPermissions('User');

      expect(response, false);
    });

    test(
        'should return false for <username> setting user permission on User',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      final response =
          await frappePermissionController.canSetUserPermissions('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canSubmit', () {
    test(
        'should return false for <admin_user> submit on Sales Invoice because doctypePerms is not loaded',
        () async {
      final response =
          await frappePermissionController.canSubmit('Sales Invoice');

      expect(response, false);
    });

    test(
        'should return true for <admin_user> submit on Sales Invoice given doctypePerms is loaded',
        () async {
      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.submit);
      final response =
          await frappePermissionController.canSubmit('Sales Invoice');

      expect(response, true);
    });

    test('should return false for <username> submit on Sales Invoice',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.submit);

      final response =
          await frappePermissionController.canSubmit('Sales Invoice');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canAmend', () {
    test(
        'should return false for <admin_user> amend on Sales Invoice because doctypePerms is not loaded',
        () async {
      final response =
          await frappePermissionController.canAmend('Sales Invoice');

      expect(response, false);
    });

    test(
        'should return true for <admin_user> amend on Sales Invoice given doctypePerms is loaded',
        () async {
      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.amend);
      final response =
          await frappePermissionController.canAmend('Sales Invoice');

      expect(response, true);
    });

    test('should return false for <username> amend on Sales Invoice',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.amend);

      final response =
          await frappePermissionController.canAmend('Sales Invoice');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  group('canRecursiveDelete', () {
    test(
        'should return false for <admin_user> recursive delete on Sales Invoice because doctypePerms is not loaded',
        () async {
      final response =
          await frappePermissionController.canRecursiveDelete('Sales Invoice');

      expect(response, false);
    });

    test(
        'should return false for <admin_user> recursive delete on Sales Invoice given doctypePerms is loaded',
        () async {
      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.amend);
      final response =
          await frappePermissionController.canRecursiveDelete('Sales Invoice');

      expect(response, false);
    });

    test(
        'should return false for <username> recursive delete on Sales Invoice',
        () async {
      await frappeAuthController.login(testEmail, testPwd);

      await frappePermissionController.hasPerm(
          doctype: 'Sales Invoice', pType: PermissionType.amend);

      final response =
          await frappePermissionController.canRecursiveDelete('Sales Invoice');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']));
  });

  tearDownAll(() async => await frappeAuthController.logout());
}
