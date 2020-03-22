import 'package:renovation_core/core.dart';
import 'package:renovation_core/meta.dart';
import 'package:renovation_core/model.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappeMetaController frappeMetaController;
  setUpAll(() async {
    await TestManager.getTestInstance();
    frappeMetaController = getFrappeMetaController();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']);
  });

  group('Get Document Count', () {
    test('should get document count successfully', () async {
      final response = await frappeMetaController.getDocCount(doctype: 'Item');

      expect(response.isSuccess, true);
      expect(response.data is int, true);
      expect(response.data > 1, true);
    });
    test('should get document count as 0 if there none', () async {
      final response =
          await frappeMetaController.getDocCount(doctype: 'Payment Entry');

      expect(response.isSuccess, true);
      expect(response.data, 0);
    });
    test('should get document count successfully with Filters', () async {
      final response =
          await frappeMetaController.getDocCount(doctype: 'Item', filters: {
        'name': ['LIKE', '%RED%']
      });

      expect(response.isSuccess, true);
      expect(response.data, 1);
    });

    test('should throw "InvalidFrappeFilter" for invalid filters', () async {
      expect(
          () async => await frappeMetaController.getDocCount(
              doctype: 'Item', filters: 'invalid-filter'),
          throwsA(TypeMatcher<InvalidFrappeFilter>()));
    });

    test('should return with error if the doctype does not exist', () async {
      final response =
          await frappeMetaController.getDocCount(doctype: 'NON EXISTING');

      expect(response.isSuccess, false);
      expect(response.error.info.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
  });

  group('Get Document Info', () {
    test('should successfully get document info', () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'Item', docname: '1234');
      expect(response.isSuccess, true);
      expect(response.data is FrappeDocInfo, true);
    });

    test('should return a failure for non-existing doctype', () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'NON EXISTING', docname: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error.info.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });

    test('should return a failure for non-existing docname', () async {
      final response = await frappeMetaController.getDocInfo(
          doctype: 'Item', docname: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error.info.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
    });
  });

  group('Get Doc Meta', () {
    test('should successfully get a doctype meta of Item', () async {
      final response = await frappeMetaController.getDocMeta(doctype: 'Item');
      expect(response.isSuccess, true);
      expect(response.data.name, 'Item');
      expect(response.data.isSubmittable, false);
      expect(response.data.isSingle, false);
    });

    test(
        'should successfully get a doctype meta of Item and save it in docTypeCache',
        () async {
      final response = await frappeMetaController.getDocMeta(doctype: 'Item');
      expect(response.isSuccess, true);
      expect(response.data.name, 'Item');
      expect(frappeMetaController.docTypeCache['Item'], isA<DocType>());
      expect(frappeMetaController.docTypeCache.keys.length > 1, true);
    });

    test('should return failure for non-existing doctype', () async {
      final response =
          await frappeMetaController.getDocMeta(doctype: 'NON EXISTING');
      expect(response.isSuccess, false);
      expect(response.error.info.httpCode, 404);
    });
  });

  group('Get Field Label', () {
    test('should successfully get a field label', () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Item', fieldName: 'item_group');
      expect(response, 'Item Group');
    });

    test('should get the standard field for doctype Item', () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Item', fieldName: 'name');
      expect(response, 'Name');
    });

    test('should return the field name as-is if the doctype does not exist ',
        () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'NON EXISTING', fieldName: 'item_group');
      expect(response, 'item_group');
    });

    test('should return the field name as-is if the field does not exist ',
        () async {
      final response = await frappeMetaController.getFieldLabel(
          doctype: 'Item', fieldName: 'non_existing_field');
      expect(response, 'non_existing_field');
    });
  });

  group('Get Report Meta', () {
    test('should get the report meta successfully', () async {
      final response = await frappeMetaController.getReportMeta(report: 'TEST');

      expect(response.isSuccess, true);
      expect(response.data.name, 'TEST');
      expect(response.data.filters, isNotNull);
      expect(response.data.filters.isNotEmpty, true);
    });
    test('should fail for non-existing report', () async {
      final response =
          await frappeMetaController.getReportMeta(report: 'NON EXISTING');

      expect(response.isSuccess, false);
      expect(
          response.error.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
      expect(response.error.type, RenovationError.NotFoundError);
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
