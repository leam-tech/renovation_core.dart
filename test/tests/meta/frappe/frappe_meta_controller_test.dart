import 'package:renovation_core/core.dart';
import 'package:renovation_core/meta.dart';
import 'package:renovation_core/model.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  late FrappeMetaController frappeMetaController;

  final validUser = TestManager.primaryUser;
  final validPwd = TestManager.primaryUserPwd;

  setUpAll(() async {
    await TestManager.getTestInstance();
    frappeMetaController = getFrappeMetaController();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(validUser, validPwd);
  });

  group('Get Document Count', () {
    test('should get document count successfully', () async {
      final response = await frappeMetaController.getDocCount(doctype: 'User');

      expect(response.isSuccess, true);
      expect(response.data is int, true);
      expect(response.data! > 1, true);
    });
    test('should get document count as 0 if there none', () async {
      final response =
          await frappeMetaController.getDocCount(doctype: 'Milestone');

      expect(response.isSuccess, true);
      expect(response.data, 0);
    });
    test('should get document count successfully with filters', () async {
      final response = await frappeMetaController.getDocCount(doctype: 'Chat Profile', filters: {
        'name': ['LIKE', validUser]
      });

      expect(response.isSuccess, true);
      expect(response.data, 1);
    });

    test('should throw "InvalidFrappeFilter" for invalid filters', () async {
      expect(
          () async => await frappeMetaController.getDocCount(
              doctype: 'User', filters: 'invalid-filter'),
          throwsA(TypeMatcher<InvalidFrappeFilter>()));
    });

    test('should return with error if the doctype does not exist', () async {
      final response =
          await frappeMetaController.getDocCount(doctype: 'NON EXISTING');

      expect(response.isSuccess, false);
      expect(response.error!.info!.httpCode, 404);
      expect(
          response.error!.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
  });

  group('Get Document Info', () {
    test('should successfully get document info of an existing document',
        () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'User', docname: validUser);
      expect(response.isSuccess, true);
      expect(response.data is FrappeDocInfo, true);
    });

    test('should return a failure for non-existing doctype', () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'NON EXISTING', docname: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error!.info!.httpCode, 404);
      expect(
          response.error!.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });

    test('should return a failure for non-existing docname', () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'Renovation Review', docname: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error!.info!.httpCode, 404);
      expect(
          response.error!.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
    });
  });

  group('Get Doc Meta', () {
    test('should successfully get a doctype meta of Renovation Review',
        () async {
      final response =
          await frappeMetaController.getDocMeta(doctype: 'Renovation Review');
      expect(response.isSuccess, true);
      expect(response.data!.name, 'Renovation Review');
      expect(response.data!.isSubmittable, true);
      expect(response.data!.isSingle, false);
    });

    test(
        'should successfully get a doctype meta of Renovation Review and save it in docTypeCache',
        () async {
      final response =
          await frappeMetaController.getDocMeta(doctype: 'Renovation Review');
      expect(response.isSuccess, true);
      expect(response.data!.name, 'Renovation Review');
      expect(frappeMetaController.docTypeCache['Renovation Review'],
          isA<DocType>());
      expect(frappeMetaController.docTypeCache.keys.length > 1, true);
    });

    test('should return failure for non-existing doctype', () async {
      final response =
          await frappeMetaController.getDocMeta(doctype: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error!.info!.httpCode, 404);
    });
  });

  group('Get Field Label', () {
    test('should successfully get a field label', () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Renovation Review', fieldName: 'reviewed_by');
      expect(response, 'Reviewed By');
    });

    test('should get the standard field for doctype Renovation Review',
        () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Renovation Review', fieldName: 'name');
      expect(response, 'Name');
    });

    test('should return the field name as-is if the doctype does not exist ',
        () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'NON EXISTING', fieldName: 'reviewed_by');
      expect(response, 'reviewed_by');
    });

    test('should return the field name as-is if the field does not exist ',
        () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Renovation Review', fieldName: 'non_existing_field');
      expect(response, 'non_existing_field');
    });
  });

  group('Get Report Meta', () {
    test('should get the report meta successfully', () async {
      final response = await frappeMetaController.getReportMeta(report: 'TEST');

      expect(response.isSuccess, true);
      expect(response.data?.name, 'TEST');
      expect(response.data?.filters, isNotNull);
      expect(response.data?.filters!.isNotEmpty, true);
    });
    test('should fail for non-existing report', () async {
      final response =
          await frappeMetaController.getReportMeta(report: 'NON EXISTING');

      expect(response.isSuccess, false);
      expect(
          response.error!.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
      expect(response.error!.type, RenovationError.NotFoundError);
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
