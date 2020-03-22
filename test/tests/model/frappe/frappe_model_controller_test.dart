import 'dart:math';

import 'package:renovation_core/auth.dart';
import 'package:renovation_core/core.dart';
import 'package:renovation_core/model.dart';
import 'package:test/test.dart';

import '../../../test_manager.dart';
import '../../../test_models/models.dart';

void main() {
  FrappeModelController frappeModelController;
  FrappeAuthController frappeAuthController;
  setUpAll(() async {
    await TestManager.getTestInstance();
    frappeModelController = getFrappeModelController();
    frappeAuthController = getFrappeAuthController();
    // Login the user to have permission to get the document
    await frappeAuthController.login(
        TestManager.getTestUserCredentials()['email'],
        TestManager.getTestUserCredentials()['password']);
  });

  group('Getting Documents', () {
    test('should get a document successfully', () async {
      final response =
          await frappeModelController.getDoc(User(), '<admin_user>');

      expect(response.isSuccess, true);
      expect(response.data.fullName, '<admin_user>');
      expect(response.httpCode, 200);
      expect(response.data, isA<User>());
    });

    test('should add to local cache if successful', () async {
      final response =
          await frappeModelController.getDoc(User(), '<admin_user>');
      final User user = frappeModelController.locals['User']['<admin_user>'];
      expect(response.isSuccess, true);
      expect(user, isA<User>());
      expect(user.fullName, '<admin_user>');
    });

    test('should throw error for doctype unspecified', () async {
      expect(
          () async => await frappeModelController.getDoc(
              User()..doctype = null, '<username>'),
          throwsA(TypeMatcher<EmptyDoctypeError>()));
    });
    test('should return failure for non-existing doctype', () async {
      final response = await frappeModelController.getDoc(
          NonExistingDocType(), 'NON-EXISTING');

      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
    test('should return failure for non-existing docs', () async {
      final response =
          await frappeModelController.getDoc(User(), 'NON-EXISTING');

      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
    });
  });

  group('Get Documents List', () {
    test('should return a list of users successfully', () async {
      final response = await frappeModelController.getList(User());

      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data, isA<List<User>>());
    });

    test('should return a failure for non-existing doctype (getList)',
        () async {
      final response =
          await frappeModelController.getList(NonExistingDocType());

      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });

    test('should return just names of users for no fields specified', () async {
      final response = await frappeModelController.getList(User());

      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data, isA<List<User>>());
      expect(response.data.every((user) => user.name != null), true);
      expect(response.data.every((user) => user.email == null), true);
    });

    test(
        'should return a list of users with just name and email defined (not null)',
        () async {
      final response = await frappeModelController
          .getList(User(), fields: ['name', 'email']);

      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data.every((user) => user.name != null), true);
      expect(response.data.every((user) => user.email != null), true);
    });

    test('should return only return 2 items on pagination', () async {
      final response = await frappeModelController.getList(User(),
          limitPageLength: 2, limitPageStart: 0);

      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data.length, 2);
    });
    test('should return tableField details', () async {
      final response =
          await frappeModelController.getList(ItemAttribute(), tableFields: {
        'item_attribute_values': ['*']
      });
      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data.isNotEmpty, true);
      expect(response.data.first.itemAttributeValues,
          isA<List<ItemAttributeValue>>());
    });
    test('should return all fields', () async {
      final response =
          await frappeModelController.getList(User(), fields: ['*']);

      expect(response.isSuccess, true);
      expect(response.httpCode, 200);
      expect(response.data.first, isA<User>());
      expect(response.data.first.toJson().keys.length > 1, true);
    });

    test('should return list with name and linkfields document within',
        () async {
      final response = await frappeModelController.getList(ItemGroup(),
          fields: ['name, parent_item_group'],
          withLinkFields: ['parent_item_group']);

      expect(response.isSuccess, true);
      expect(response.data.every((itemGroup) => itemGroup.name != null), true);
      expect(
          response.data.any((itemGroup) =>
              itemGroup.parentItemGroupDoc != null &&
              itemGroup.parentItemGroupDoc is ParentItemGroup),
          true);
    });

    test('should return list without non-existing linkfields', () async {
      final response = await frappeModelController.getList(ItemGroup(),
          fields: ['name, parent_item_group'],
          withLinkFields: ['NON-EXISTING']);

      expect(response.isSuccess, true);
      expect(response.data.every((itemGroup) => itemGroup is ItemGroup), true);
      expect(
          response.data
              .any((itemGroup) => itemGroup.parentItemGroupDoc == null),
          true);
    });

    test('should return list of user with filters type 1', () async {
      final response = await frappeModelController
          .getList(User(), filters: {'name': '<admin_user>', 'enabled': 1});

      expect(response.isSuccess, true);
      expect(response.data.length, 1);
      expect(response.data.first.name, '<admin_user>');
    });

    test('should return list of user with filters type 2', () async {
      final response = await frappeModelController.getList(User(), filters: [
        ['name', '=', '<admin_user>']
      ]);

      expect(response.isSuccess, true);
      expect(response.data.length, 1);
      expect(response.data.first.name, '<admin_user>');
    });

    test('should return list of user with filters type 3', () async {
      final response = await frappeModelController.getList(User(), filters: {
        'name': ['=', '<admin_user>']
      });

      expect(response.isSuccess, true);
      expect(response.data.length, 1);
      expect(response.data.first.name, '<admin_user>');
    });

    // More tests will be added to filters.dart in a separate group.
    test(
        'should throw InvalidFrappeFilter in case the filters are in the wrong format',
        () async {
      expect(
          () async => await frappeModelController.getList(User(), filters: {
                'user': {
                  'field': {'name': '<admin_user>'}
                }
              }),
          throwsA(TypeMatcher<InvalidFrappeFilter>()));
    });

    test('should return a list of length 0 for a filter not satisfied',
        () async {
      final response = await frappeModelController
          .getList(User(), filters: {'name': 'NONEXISTING'});

      expect(response.isSuccess, true);
      expect(response.data.isEmpty, true);
    });
  });

  group('Delete Document', () {
    test(
        'should delete a RenovationUserAgreement successfully from backend and locally',
        () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'TESTING DELETION';
      final savedDoc = await frappeModelController.saveDoc(newDoc);
      expect(savedDoc.isSuccess, true);
      final deletedDoc = await frappeModelController.deleteDoc(
          savedDoc.data.doctype, savedDoc.data.name);
      expect(deletedDoc.isSuccess, true);
      expect(deletedDoc.data, 'TESTING DELETION');
      expect(
          frappeModelController.getDocFromCache(
              'Renovation User Agreement', 'TESTING DELETION'),
          isNull);
    });

    test("should fail to delete a doctype that doesn't exist", () async {
      final response = await frappeModelController.deleteDoc(
          'NONEXISTING', 'TESTING SUBMISSION');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(response.error.title,
          FrappeModelController.DOCTYPE_OR_DOCNAME_NOT_EXIST_TITLE);
    });

    test("should fail to delete a docname that doesn't exist", () async {
      final response = await frappeModelController.deleteDoc(
          'Renovation User Agreement', 'non_existing');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(response.error.title,
          FrappeModelController.DOCTYPE_OR_DOCNAME_NOT_EXIST_TITLE);
    });

    test(
        'should throw InvalidDoctype when doctype is null',
        () async => expect(
            () async => await frappeModelController.deleteDoc(null, 'TESTING'),
            throwsA(TypeMatcher<EmptyDoctypeError>())));
    test(
        'should throw InvalidDoctype when doctype is empty string',
        () async => expect(
            () async => await frappeModelController.deleteDoc('', 'TESTING'),
            throwsA(TypeMatcher<EmptyDoctypeError>())));

    test(
        'should throw InvalidDocName when docname is null',
        () async => expect(
            () async => await frappeModelController.deleteDoc('TETSING', null),
            throwsA(TypeMatcher<EmptyDocNameError>())));
    test(
        'should throw InvalidDocName when docname is empty string',
        () async => expect(
            () async => await frappeModelController.deleteDoc('TESTING', ''),
            throwsA(TypeMatcher<EmptyDocNameError>())));

    // Just in case the test fails
    tearDownAll(() => frappeModelController.deleteDoc(
        'Renovation User Agreement', 'TESTING DELETION'));
  });

  group('Get Value', () {
    test('should return a Map<String, dynamic> successfully', () async {
      final response = await frappeModelController.getValue(
          'User', '<admin_user>', 'email');
      expect(response.isSuccess, true);
      expect(response.data, isA<Map<String, dynamic>>());
      expect(response.data['email'], 'admin@example.com');
    });
    test('should return failure for non-existing doctype', () async {
      final response = await frappeModelController.getValue(
          'NON-EXISTING', '<admin_user>', 'email');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(response.error.type, RenovationError.NotFoundError);
    });
    test('should return failure for non-existing document', () async {
      final response =
          await frappeModelController.getValue('User', 'non_existing', 'email');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(response.error.type, RenovationError.NotFoundError);
    });
    test('should return failure for non-existing field', () async {
      final response = await frappeModelController.getValue(
          'User', '<admin_user>', 'non_existing');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(response.error.type, RenovationError.NotFoundError);
    });
  });

  group('Set Value', () {
    test('should set value successfully', () async {
      final random = Random().nextInt(10).toString();

      final response = await frappeModelController.setValue(
          User(), '<username>', 'middle_name', random);
      expect(response.isSuccess, true);
      expect(response.data.middleName, random);
    });

    test('should return failure for non-existing doctype', () async {
      final response = await frappeModelController.setValue(
          User()..doctype = 'NON EXISTING',
          '<username>',
          'email',
          '<username>');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });

    test('should return failure for non-existing document', () async {
      final response = await frappeModelController.setValue(
          User(), 'non_existing', 'email', '<username>');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
    });

    test('should throw InvalidFrappeFieldValue if docValue is not DBValue',
        () async {
      expect(
          () async => await frappeModelController.setValue(
              User(), '<admin_user>', 'middle_name', <String, dynamic>{}),
          throwsA(TypeMatcher<InvalidFrappeFieldValue>()));
    });
  });

  group('Save Document', () {
    test('should save a new document successfully', () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'TESTING SAVE';
      final savedDoc = await frappeModelController.saveDoc(newDoc);
      expect(savedDoc.isSuccess, true);
      expect(savedDoc.data, isA<RenovationUserAgreement>());
      expect(savedDoc.data.docStatus, FrappeDocStatus.Draft);
      // Checking for locally saved doc
      expect(
          frappeModelController
              .getDocFromCache<RenovationUserAgreement>(
                  'Renovation User Agreement', 'TESTING SAVE')
              .name,
          'TESTING SAVE');
    });

    test('should save an existing doc successfully and update it locally',
        () async {
      final getDocResponse =
          await frappeModelController.getDoc(User(), '<admin_user>');
      final user = getDocResponse.data;

      user..middleName = 'testing_save_doc';

      final response = await frappeModelController.saveDoc(user);
      expect(response.isSuccess, true);
      expect(response.data.middleName, 'testing_save_doc');
      // Checking for locally saved doc
      expect(
          frappeModelController
              .getDocFromCache<User>('User', '<admin_user>')
              .middleName,
          'testing_save_doc');
    });

    test('should fail if duplicated', () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'TESTING SAVE';
      final response = await frappeModelController.saveDoc(newDoc);
      expect(response.isSuccess, false);
      expect(response.httpCode, 409);
      expect(response.error.title, 'Duplicate document found');
    });

    tearDownAll(() => frappeModelController.deleteDoc(
        'Renovation User Agreement', 'TESTING SAVE'));
  });

  group('Document Submission', () {
    test('should successfully submit a document', () async {
      final userAgreement =
          frappeModelController.newDoc(RenovationUserAgreement());
      userAgreement.title = 'TESTING SUBMISSION';
      final response = await frappeModelController.submitDoc(userAgreement);
      expect(response.isSuccess, true);
      expect(response.data.title, 'TESTING SUBMISSION');
      expect(response.data.docStatus, FrappeDocStatus.Submitted);
    });
    test('should fail for non-existing doctype', () async {
      final userAgreement = frappeModelController
          .newDoc(RenovationUserAgreement()..doctype = 'NON-EXISTING');

      final response = await frappeModelController.submitDoc(userAgreement);
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
    test('should fail if duplicated submitted document', () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'ANOTHER TESTING SUBMISSION';
      final response = await frappeModelController.submitDoc(newDoc);
      expect(response.isSuccess, false);
      expect(response.httpCode, 409);
      expect(response.error.title, 'Duplicate document found');
      expect(response.error.type, RenovationError.DuplicateEntryError);
    });

    test('should throw NotSubmittableDocError for non-submittable document',
        () async {
      expect(
          () async => await frappeModelController
              .submitDoc(frappeModelController.newDoc(ItemGroup())),
          throwsA(TypeMatcher<NotSubmittableDocError>()));
    });

    tearDownAll(() async {
      final getDoc = await frappeModelController.getDoc(
          RenovationUserAgreement(), 'TESTING SUBMISSION');
      if (getDoc.isSuccess) {
        final cancelDoc = await frappeModelController.cancelDoc(getDoc.data);
        await frappeModelController.deleteDoc(
            '${cancelDoc.data.doctype}', '${cancelDoc.data.name}');
      }
    });
  });

  group('saveSubmitDoc', () {
    test('should successfully save and submit a document', () async {
      final userAgreement =
          frappeModelController.newDoc(RenovationUserAgreement());
      userAgreement.title = 'TESTING SAVING AND SUBMISSION';
      final response = await frappeModelController.saveSubmitDoc(userAgreement);
      expect(response.isSuccess, true);
      expect(response.data.title, 'TESTING SAVING AND SUBMISSION');
      expect(response.data.docStatus, FrappeDocStatus.Submitted);
    });
    test('should fail for non-existing doctype', () async {
      final userAgreement = frappeModelController
          .newDoc(RenovationUserAgreement()..doctype = 'NON-EXISTING');

      final response = await frappeModelController.saveSubmitDoc(userAgreement);
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
    test('should fail if duplicated submitted document', () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'ANOTHER TESTING SAVING AND SUBMISSION';
      final response = await frappeModelController.submitDoc(newDoc);
      expect(response.isSuccess, false);
      expect(response.httpCode, 409);
      expect(response.error.title, 'Duplicate document found');
      expect(response.error.type, RenovationError.DuplicateEntryError);
    });

    test('should throw NotSubmittableDocError for non-submittable document',
        () async {
      expect(
          () async => await frappeModelController
              .saveSubmitDoc(frappeModelController.newDoc(ItemGroup())),
          throwsA(TypeMatcher<NotSubmittableDocError>()));
    });

    tearDownAll(() async {
      final getDoc = await frappeModelController.getDoc(
          RenovationUserAgreement(), 'TESTING SAVING AND SUBMISSION');
      if (getDoc.isSuccess) {
        final cancelDoc = await frappeModelController.cancelDoc(getDoc.data);
        await frappeModelController.deleteDoc(
            '${cancelDoc.data.doctype}', '${cancelDoc.data.name}');
      }
    });
  });

  group('amendDoc', () {
    test('should successfully amend a doc', () async {
      final doc = await frappeModelController.getDoc(User(), '<admin_user>',
          forceFetch: true);

      final amendedDoc = frappeModelController
          .amendDoc(doc.data..docStatus = FrappeDocStatus.Submitted);

      expect(amendedDoc.name.contains('New'), true);
      expect(amendedDoc.isLocal, true);
      expect(amendedDoc.unsaved, true);
      expect(amendedDoc.amendedFrom, '<admin_user>');
      expect(frappeModelController.locals['User'][amendedDoc.name], isNotNull);
    });

    test('should throw NotASubmittedDocument if document is not submitted',
        () async {
      final amendedDoc = await frappeModelController
          .getDoc(User(), '<admin_user>', forceFetch: true);

      expect(() => frappeModelController.amendDoc(amendedDoc.data),
          throwsA(TypeMatcher<NotASubmittedDocument>()));
    });
  });

  group('copyDoc', () {
    test('should successfully copy a doc', () async {
      final doc = await frappeModelController.getDoc(User(), '<admin_user>');

      final copy = frappeModelController.copyDoc(doc.data);

      expect(copy.name.contains('New'), true);
      expect(copy.isLocal, true);
      expect(copy.unsaved, true);
      expect(frappeModelController.locals['User'][copy.name], isNotNull);
    });

    test('should throw EmptyDoctypeError if doctype is not defined', () async {
      final doc = await frappeModelController.getDoc(User(), '<admin_user>');

      doc.data.doctype = null;
      expect(() => frappeModelController.copyDoc(doc.data),
          throwsA(TypeMatcher<EmptyDoctypeError>()));
    });
  });

  group('Document Cancellation', () {
    RenovationUserAgreement userAgreement;

    setUpAll(() async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'TESTING CANCELLATION';
      userAgreement = (await frappeModelController.submitDoc(newDoc)).data;
    });

    test(
        'should successfully cancel a submitted document and update it locally',
        () async {
      final response = await frappeModelController.cancelDoc(userAgreement);
      expect(response.isSuccess, true);
      expect(response.data.docStatus, FrappeDocStatus.Cancelled);
      expect(
          frappeModelController
              .getDocFromCache<RenovationUserAgreement>(
                  'Renovation User Agreement', 'TESTING CANCELLATION')
              .docStatus,
          FrappeDocStatus.Cancelled);
    });

    test('should fail for non-submitted documents', () async {
      expect(
          () async => await frappeModelController
              .cancelDoc(RenovationUserAgreement()..name = 'TESTING'),
          throwsA(TypeMatcher<NotASubmittedDocument>()));
    });

    test('should fail for non-existing doctype', () async {
      final newDoc = frappeModelController.newDoc(NonExistingDocType());
      newDoc.name = 'ANOTHER TESTING SUBMISSION';
      newDoc.docStatus = FrappeDocStatus.Submitted;

      final cancelDoc = await frappeModelController.cancelDoc(newDoc);
      expect(cancelDoc.isSuccess, false);
      expect(cancelDoc.httpCode, 404);
      expect(
          cancelDoc.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
      expect(cancelDoc.error.type, RenovationError.NotFoundError);
    });

    test('should fail for non-existing document', () async {
      final newDoc = frappeModelController.newDoc(RenovationUserAgreement());
      newDoc.title = 'ANOTHER TESTING SUBMISSION';
      newDoc.docStatus = FrappeDocStatus.Submitted;

      final cancelDoc = await frappeModelController.cancelDoc(newDoc);
      expect(cancelDoc.isSuccess, false);
      expect(cancelDoc.httpCode, 404);
      expect(
          cancelDoc.error.title, FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
      expect(cancelDoc.error.type, RenovationError.NotFoundError);
    });

    tearDownAll(() async {
      await frappeModelController.cancelDoc(userAgreement);
      await frappeModelController.deleteDoc(
          'Renovation User Agreement', 'TESTING CANCELLATION');
    });
  });

  group('SearchLink', () {
    test('should get a list of results', () async {
      final response =
          await frappeModelController.searchLink(doctype: 'Item', txt: '1234');

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
    });

    test('should get a list of results using options', () async {
      final response = await frappeModelController.searchLink(
          doctype: 'Item',
          txt: 'pro',
          options: <String, dynamic>{'searchField': 'item_group'});

      expect(response.isSuccess, true);
      expect(response.data.isNotEmpty, true);
    });

    test('should get an empty list for non-matching query', () async {
      final response = await frappeModelController.searchLink(
          doctype: 'Item', txt: 'NONEXISTING');
      expect(response.isSuccess, true);
      expect(response.data.isEmpty, true);
    });
    test('should fail for non-existing doctype on search', () async {
      final response = await frappeModelController.searchLink(
          doctype: 'NONEXISTING', txt: '1234');
      expect(response.isSuccess, false);
      expect(response.httpCode, 404);
      expect(
          response.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
      expect(response.error.type, RenovationError.NotFoundError);
    });
  });

  group('Document Assignment', () {
    group('Assign Document', () {
      test('should successfully assign a doc to a user', () async {
        final response = await frappeModelController.assignDoc(
            assignTo: null,
            myself: true,
            docName: '1234',
            doctype: 'Item',
            priority: Priority.High,
            description: 'TESTING ASSIGN');
        expect(response.isSuccess, true);
        expect(response.data, true);
      });

      test('should successfully assign multiple docs to a user', () async {
        final response = await frappeModelController.assignDoc(
            assignTo: null,
            myself: true,
            docNames: ['1234-RED', '1234-BLU'],
            bulkAssign: true,
            doctype: 'Item',
            priority: Priority.High,
            description: 'TESTING ASSIGN');
        expect(response.isSuccess, true);
        expect(response.data, true);
      });

      test('should fail assign a doc to a user on non-existing doctype',
          () async {
        final response = await frappeModelController.assignDoc(
            assignTo: null,
            myself: true,
            docName: '1234',
            doctype: 'NONEXISTING',
            priority: Priority.High,
            description: 'TESTING ASSIGN');
        expect(response.isSuccess, false);
        expect(response.httpCode, 417);
      });

      tearDownAll(() async {
        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234',
            unAssignFrom: frappeAuthController.currentUser);
        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234-RED',
            unAssignFrom: frappeAuthController.currentUser);
        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234-BLU',
            unAssignFrom: frappeAuthController.currentUser);
      });
    });

    group('Unassign Document', () {
      setUpAll(() async {
        await frappeModelController.assignDoc(
            assignTo: null,
            myself: true,
            docName: '1234-BLU',
            doctype: 'Item',
            priority: Priority.High,
            description: 'TESTING UNASSIGN');
      });
      test('should successfully unassign a user from a doc', () async {
        final response = await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234-BLU',
            unAssignFrom: frappeAuthController.currentUser);
        expect(response.isSuccess, true);
        expect(response.data, true);
      });
    });

    group('Complete Doc Assignment', () {
      setUpAll(() async {
        await frappeModelController.assignDoc(
            assignTo: null,
            myself: true,
            docName: '1234',
            doctype: 'Item',
            priority: Priority.High,
            description: 'TESTING COMPLETE ASSIGN');
      });
      test('should successfully complete an assigned task', () async {
        final response = await frappeModelController.completeDocAssignment(
            doctype: 'Item',
            docName: '1234',
            assignedTo: frappeAuthController.currentUser);
        expect(response.isSuccess, true);
        expect(response.data, true);
      });
      tearDownAll(() async {
        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234',
            unAssignFrom: frappeAuthController.currentUser);
      });
    });

    group('Get Docs Assigned to User', () {
      setUpAll(() async {
        await frappeModelController.assignDoc(
            assignTo: '<username>',
            docName: '1234-RED',
            doctype: 'Item',
            priority: Priority.Medium,
            description: 'TESTING GET DOCS');

        await frappeModelController.assignDoc(
            assignTo: '<username>',
            docName: '1234-BLU',
            doctype: 'Item',
            priority: Priority.Low,
            description: 'TESTING GET DOCS');

        await frappeModelController.assignDoc(
            assignTo: '<username>',
            docName: '<username>',
            doctype: 'User',
            priority: Priority.Low,
            description: 'TESTING GET DOCS');
      });

      test('should successfully get all docs assigned to a user', () async {
        final response = await frappeModelController.getDocsAssignedToUser(
            assignedTo: '<username>');
        expect(response.isSuccess, true);
        expect(response.data.isNotEmpty, true);
        expect(response.data.length, 3);
        expect(response.data.first.assignedTo, '<username>');
        expect(response.data.first.description, 'TESTING GET DOCS');
      });

      test(
          'should successfully get all docs assigned to a user filtered by doctype',
          () async {
        final response = await frappeModelController.getDocsAssignedToUser(
            assignedTo: '<username>', doctype: 'Item');
        expect(response.isSuccess, true);
        expect(response.data.isNotEmpty, true);
        expect(response.data.length, 2);
        expect(response.data.first.assignedTo, '<username>');
        expect(response.data.first.description, 'TESTING GET DOCS');
      });

      tearDownAll(() async {
        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234-RED',
            unAssignFrom: '<username>');

        await frappeModelController.unAssignDoc(
            doctype: 'Item',
            docName: '1234-BLU',
            unAssignFrom: '<username>');

        await frappeModelController.unAssignDoc(
            doctype: 'User',
            docName: '<username>',
            unAssignFrom: '<username>');
      });
    });

    group('Get Users Assigned to Doc', () {
      setUpAll(() async {
        await frappeModelController.assignDoc(
            assignTo: '<admin_user>',
            docName: '1234-BLU',
            doctype: 'Item',
            priority: Priority.Medium,
            description: 'TESTING GET USER');

        await frappeModelController.assignDoc(
            assignTo: '<username>',
            docName: '1234-BLU',
            doctype: 'Item',
            priority: Priority.Low,
            description: 'TESTING GET USERS');
      });

      test('should successfully get all users assigned to a doc', () async {
        final response = await frappeModelController.getUsersAssignedToDoc(
            doctype: 'Item', docName: '1234-BLU');
        expect(response.isSuccess, true);
        expect(response.data.isNotEmpty, true);
        expect(response.data.first is ToDo, true);
        expect(response.data.length, 2);
      });
    });
  });

  group('Tags', () {
    // Just to make sure the versions are loaded
    setUpAll(() async => await Renovation().frappe.loadAppVersions());

    group('Add Tags', () {
      test('should successfully tag a document', () async {
        final response = await frappeModelController.addTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');

        expect(response.isSuccess, true);
        expect(response.data, 'TEST TAG');
      });
      test('should fail to add tag on non-existing doctype', () async {
        final response = await frappeModelController.addTag(
            doctype: 'non-existing', docName: '1234', tag: 'TEST TAG');

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.title,
            FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
      });
      test('should fail to add tag on non-existing document', () async {
        final response = await frappeModelController.addTag(
            doctype: 'Item', docName: 'non_existing', tag: 'TEST TAG');

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.title,
            FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
      });
      test('should not fail to add tag on document with duplicate tag',
          () async {
        final addAnotherTagResponse = await frappeModelController.addTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');
        expect(addAnotherTagResponse.isSuccess, true);
        expect(addAnotherTagResponse.data, 'TEST TAG');
      });
      test('should not fail for empty string', () async {
        final response = await frappeModelController.addTag(
            doctype: 'Item', docName: '1234', tag: '');

        expect(response.isSuccess, true);
        expect(response.data.isEmpty, true);
      });
      tearDownAll(() async {
        await frappeModelController.removeTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');
        await frappeModelController.removeTag(
            doctype: 'Item', docName: '1234', tag: '');
      });
    });

    group('Remove Tags', () {
      setUpAll(() async {
        await frappeModelController.addTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');
      });
      test('should successfully remove a tag from a document', () async {
        final response = await frappeModelController.removeTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');

        expect(response.isSuccess, true);
        expect(response.data, 'TEST TAG');
      });
      test('should fail to remove a tag on non-existing doctype', () async {
        final response = await frappeModelController.removeTag(
            doctype: 'non-existing', docName: '1234', tag: 'TEST TAG');

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.title,
            FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
      });
      test('should fail to remove tag on non-existing document', () async {
        final response = await frappeModelController.removeTag(
            doctype: 'Item', docName: 'non_existing', tag: 'TEST TAG');

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.title,
            FrappeModelController.DOCNAME_NOT_EXIST_TITLE);
      });
      test('should not fail for non-existing tag', () async {
        final response = await frappeModelController.removeTag(
            doctype: 'Item', docName: '1234', tag: 'non_existing');

        expect(response.isSuccess, true);
      });
    });

    group('Get Tagged Docs', () {
      setUpAll(() async {
        await frappeModelController.addTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');
      });

      test('should successfully get tagged documents of a certain doctype',
          () async {
        final response =
            await frappeModelController.getTaggedDocs(doctype: 'Item');

        expect(response.isSuccess, true);
        expect(response.data.isNotEmpty, true);
      });

      test(
          'should successfully get tagged documents of a certain doctype and a certain tag',
          () async {
        final response = await frappeModelController.getTaggedDocs(
            doctype: 'Item', tag: 'TEST TAG');
        expect(response.isSuccess, true);
        expect(response.data.isNotEmpty, true);
      });
      test('should get an empty list of a certain doctype and a certain tag',
          () async {
        final response = await frappeModelController.getTaggedDocs(
            doctype: 'Item', tag: 'NON EXISTING');

        expect(response.isSuccess, true);
        expect(response.data.isEmpty, true);
      });
      test('should fail to get tagged docs on non-existing doctype', () async {
        final response = await frappeModelController.getTaggedDocs(
            doctype: 'NONEXISTING', tag: 'TEST TAG');

        expect(response.isSuccess, false);
        expect(response.httpCode, 404);
        expect(response.error.title,
            FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
      });

      tearDownAll(() async {
        await frappeModelController.removeTag(
            doctype: 'Item', docName: '1234', tag: 'TEST TAG');
      });
    });

    group('Get Tag', () {
      // TODO
      test('should get all tags of a doctype', () async {});
    });
  });

  group('Get Report', () {
    test('should get report successfully', () async {
      final response = await frappeModelController.getReport(report: 'TEST');

      expect(response.isSuccess, true);
      expect(response.data.result.isNotEmpty, true);
      expect(response.data.columns.isNotEmpty, true);
    });
    test('should get report with filters successfully', () async {
      //TODO
    });
    test('should get failure for non-existing report', () async {
      final value =
          await frappeModelController.getReport(report: 'NON EXISTING REPORT');
      expect(value.isSuccess, false);
      expect(value.httpCode, 404);
      expect(value.error.title, FrappeModelController.DOCTYPE_NOT_EXIST_TITLE);
    });
  });

  tearDownAll(() async {
    await frappeModelController.deleteDoc(
        'Renovation User Agreement', 'TESTING SUBMISSION');
    await frappeAuthController.logout();
  });
}
