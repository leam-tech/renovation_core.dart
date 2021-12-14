import 'package:renovation_core/auth.dart';
import 'package:renovation_core/core.dart';
import 'package:renovation_core/perm.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappePermissionController? frappePermissionController;
  FrappeAuthController? frappeAuthController;

  final validUser = TestManager.primaryUser;
  final validPwd = TestManager.primaryUserPwd;

  final validSecondUser = TestManager.secondaryUser;
  final validSecondUserPwd = TestManager.secondaryUserPwd;

  setUp(() async {
    await TestManager.getTestInstance();
    frappePermissionController = getFrappePermissionController();
    frappeAuthController = getFrappeAuthController();
    // Login the user to have permission to get the document
    await frappeAuthController!.login(validUser, validPwd);
  });

  group('Load Basic Permission', () {
    test(
        'should successfully load basic permissions of a System Manager user from the backend',
        () async {
      final response = await frappePermissionController!.loadBasicPerms();

      expect(response.isSuccess, true);
      expect(response.data!.can_read!.isNotEmpty, true);
      expect(frappePermissionController!.basicPerms, isNotNull);
    });

    test('should successfully load basic permissions of a non-System Manager',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.loadBasicPerms();

      expect(response.isSuccess, true);
      expect(response.data!.can_set_user_permissions!.isEmpty, true);
    });

    //TODO: Check fail cases

    // Re-login to a System Manager user for the rest of the tests.
    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('Get Permissions of a doctype', () {
    test(
        'should get the list of permissions of a doctype successfully for a System Manager user',
        () async {
      final response =
          await frappePermissionController!.getPerm(doctype: 'User');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.first.ifOwner, false);
      expect(response.data.first.create, true);
      expect(response.data.first.submit, false);
      expect(response.data.first.permLevel, 0);
      expect(response.data.last.permLevel, 1);
    });

    test(
        'should get the list of permissions of a doctype successfully for a non-System Manager user',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response =
          await frappePermissionController!.getPerm(doctype: 'User');

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
          await frappePermissionController!.getPerm(doctype: 'NON EXISTING');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
      expect(response.data.length, 1);
      expect(response.data.first.read, isNotNull);
      expect(response.data.first.permLevel, 0);
      expect(response.data.first.ifOwner, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('hasPerm', () {
    test('should return true for a System Manager user to create User',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', pType: PermissionType.create);

      expect(response, true);
    });

    test('should return false for a System Manager user to submit User',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', pType: PermissionType.submit);

      expect(response, false);
    });

    test(
        'should return true for a System Manager user to write User with permLevel 1',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', pType: PermissionType.write, permLevel: 1);

      expect(response, true);
    });

    test(
        'should return false for a System Manager user to create User with permLevel 1',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', pType: PermissionType.create, permLevel: 1);

      expect(response, false);
    });

    test('should return false for non existin permLevel', () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', pType: PermissionType.read, permLevel: 2);

      expect(response, false);
    });

    test('should return false for non existin doctype', () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'NON EXISTING', pType: PermissionType.read, permLevel: 2);

      expect(response, false);
    });

    test(
        'should return true for write a System Manager user of a specific doctype',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', docname: validUser, pType: PermissionType.write);

      expect(response, true);
    });

    test(
        'should return false for submit a System Manager user of a specific doctype',
        () async {
      final response = await frappePermissionController!.hasPerm(
          doctype: 'User', docname: validUser, pType: PermissionType.submit);

      expect(response, false);
    });

    test('should throw InvalidPermissionLevel if permLevel not between 0-9',
        () async {
      expect(
          () async => await frappePermissionController!.hasPerm(
              doctype: 'User', pType: PermissionType.read, permLevel: 10),
          throwsA(TypeMatcher<InvalidPermissionLevel>()));
    });
  });

  group('hasPerms', () {
    test(
        'should return true for a System Manager user to create, read and write User',
        () async {
      final response = await frappePermissionController!.hasPerms(
          doctype: 'User',
          pTypes: [
            PermissionType.create,
            PermissionType.read,
            PermissionType.write
          ]);

      expect(response, true);
    });

    test(
        'should return false for create, submit, read and write a System Manager user of a specific doctype',
        () async {
      final response =
          await frappePermissionController!.hasPerms(doctype: 'User', pTypes: [
        PermissionType.create,
        PermissionType.submit,
        PermissionType.read,
        PermissionType.write
      ]);

      expect(response, false);
    });
  });

  group('canRead', () {
    test('should return true for a System Manager user read on System Settings',
        () async {
      final response =
          await frappePermissionController!.canRead('System Settings');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user read on System Settings',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response =
          await frappePermissionController!.canRead('System Settings');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canCreate', () {
    test('should return true for a System Manager user create on User',
        () async {
      final response = await frappePermissionController!.canCreate('User');

      expect(response, true);
    });

    test('should return false for a non-System Manager user create on Use',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.canCreate('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canWrite', () {
    test(
        'should return true for a System Manager user write on System Settings',
        () async {
      final response =
          await frappePermissionController!.canWrite('System Settings');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user create on System Settings',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response =
          await frappePermissionController!.canWrite('System Settings');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canCancel', () {
    test(
        'should return true for a System Manager user cancel on Renovation User Agreement',
        () async {
      final response = await frappePermissionController!
          .canCancel('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user create on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!
          .canCancel('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canDelete', () {
    test('should return true for a System Manager user delete on User',
        () async {
      final response = await frappePermissionController!.canDelete('User');

      expect(response, true);
    });

    test('should return false for a non-System Manager user delete on User',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.canDelete('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canImport', () {
    test('should return true for a System Manager user import on User',
        () async {
      final response = await frappePermissionController!.canImport('User');

      expect(response, true);
    });

    test('should return false for a non-System Manager user import on User',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.canImport('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canExport', () {
    test(
        'should return true for a System Manager user export on Renovation User Agreement',
        () async {
      final response = await frappePermissionController!
          .canExport('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user export on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!
          .canExport('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canPrint', () {
    test(
        'should return true for a System Manager user print on Renovation User Agreement',
        () async {
      final response = await frappePermissionController!
          .canPrint('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user print on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!
          .canPrint('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canEmail', () {
    test('should return true for a System Manager user email on User',
        () async {
      final response = await frappePermissionController!.canEmail('User');

      expect(response, true);
    });

    test('should return false for a non-System Manager user print on User',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.canEmail('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canSearch', () {
    test('should return true for a System Manager user search on Bank',
        () async {
      final response = await frappePermissionController!.canSearch('Bank');

      expect(response, true);
    });

    test('should return false for a non-System Manager user search on Bank',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!.canSearch('Bank');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canGetReport', () {
    test(
        'should return true for a System Manager user get report on Renovation User Agreement',
        () async {
      final response = await frappePermissionController!
          .canGetReport('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user get report on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response = await frappePermissionController!
          .canGetReport('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canSetUserPermission', () {
    test(
        'should return false for a System Manager user setting user permission on User',
        () async {
      final response =
          await frappePermissionController!.canSetUserPermissions('User');

      expect(response, false);
    });

    test(
        'should return false for a non-System Manager user setting user permission on User',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      final response =
          await frappePermissionController!.canSetUserPermissions('User');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canSubmit', () {
    test(
        'should return false for a System Manager user submit on Renovation User Agreement because doctypePerms is not loaded',
        () async {
      final response = await frappePermissionController!
          .canSubmit('Renovation User Agreement');

      expect(response, false);
    });

    test(
        'should return true for a System Manager user submit on Renovation User Agreement given doctypePerms is loaded',
        () async {
      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.submit);
      final response = await frappePermissionController!
          .canSubmit('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user submit on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.submit);

      final response = await frappePermissionController!
          .canSubmit('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canAmend', () {
    test(
        'should return false for a System Manager user amend on Renovation User Agreement because doctypePerms is not loaded',
        () async {
      final response = await frappePermissionController!
          .canAmend('Renovation User Agreement');

      expect(response, false);
    });

    test(
        'should return true for a System Manager user amend on Renovation User Agreement given doctypePerms is loaded',
        () async {
      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.amend);
      final response = await frappePermissionController!
          .canAmend('Renovation User Agreement');

      expect(response, true);
    });

    test(
        'should return false for a non-System Manager user amend on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.amend);

      final response = await frappePermissionController!
          .canAmend('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  group('canRecursiveDelete', () {
    test(
        'should return false for a System Manager user recursive delete on Renovation User Agreement because doctypePerms is not loaded',
        () async {
      final response = await frappePermissionController!
          .canRecursiveDelete('Renovation User Agreement');

      expect(response, false);
    });

    test(
        'should return false for a System Manager user recursive delete on Renovation User Agreement given doctypePerms is loaded',
        () async {
      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.amend);
      final response = await frappePermissionController!
          .canRecursiveDelete('Renovation User Agreement');

      expect(response, false);
    });

    test(
        'should return false for a non-System Manager user recursive delete on Renovation User Agreement',
        () async {
      await frappeAuthController!.login(validSecondUser, validSecondUserPwd);

      await frappePermissionController!.hasPerm(
          doctype: 'Renovation User Agreement', pType: PermissionType.amend);

      final response = await frappePermissionController!
          .canRecursiveDelete('Renovation User Agreement');

      expect(response, false);
    });

    tearDownAll(() => frappeAuthController!.login(validUser, validPwd));
  });

  tearDownAll(() async => await frappeAuthController!.logout());
}
