import 'dart:convert';
import 'dart:io';

import 'package:renovation_core/core.dart';
import 'package:renovation_core/storage.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import '../../../test_manager.dart';

void main() {
  FrappeStorageController frappeStorageController;
  Renovation renovation;

  final newFolder = 'New Folder';
  final existingFolder = TestManager.getVariable(EnvVariables.ExistingFolder);

  final validUser = TestManager.primaryUser;
  final validPwd = TestManager.primaryUserPwd;

  setUpAll(() async {
    renovation = await TestManager.getTestInstance();
    frappeStorageController = getFrappeStorageController();
    // Login the user to have permission to get the document
    await getFrappeAuthController().login(validUser, validPwd);
  });

  group('validateUploadArgs', () {
    test(
        'should throw MissingFileError when file is null wihin FrappeUploadParams',
        () async {
      expect(
          () => frappeStorageController.validateUploadFileArgs(
              FrappeUploadFileParams(file: null, fileName: 'test')),
          throwsA(TypeMatcher<MissingFileError>()));
    });

    test(
        'should throw MissingFileNameError when file is null wihin FrappeUploadParams',
        () async {
      expect(
          () => frappeStorageController.validateUploadFileArgs(
              FrappeUploadFileParams(file: File(''), fileName: '')),
          throwsA(TypeMatcher<MissingFileNameError>()));
    });
  });

  group('getUrl', () {
    test('should return null if the input is null', () {
      final fullUrl = frappeStorageController.getUrl(null);
      expect(fullUrl, isNull);
    });

    test('should return the url as-is since it contains http', () {
      final fullUrl =
          frappeStorageController.getUrl('http://test.com/image.jpeg');
      expect(fullUrl, 'http://test.com/image.jpeg');
    });

    test(
        'should return the url appended with hostURL if the input is file path',
        () {
      final fullUrl = frappeStorageController.getUrl('/image.jpeg');
      expect(fullUrl, Renovation().config.hostUrl + '/image.jpeg');
    });
  });

  group('checkFolderExists', () {
    test('should return success and true value for data for existing folder',
        () async {
      final response = await frappeStorageController
          .checkFolderExists('Home/$existingFolder');
      expect(response.isSuccess, true);
      expect(response.data, true);
    });

    test(
        'should return success and false value for data for non-existing folder',
        () async {
      final response =
          await frappeStorageController.checkFolderExists('Home/non_existing');
      expect(response.isSuccess, true);
      expect(response.data, false);
    });
  });

  group('createFolder', () {
    test('should return a failure if the folder name includes a forward slash',
        () async {
      final response = await frappeStorageController.createFolder(
          folderName: 'main/subdirectory');

      expect(response.isSuccess, false);
      expect(response.httpCode, 412);
      expect(response.error.title, 'Invalid Folder Name');
    });

    test('should create folder successfully in backend with parent folder',
        () async {
      final response =
          await frappeStorageController.createFolder(folderName: newFolder);

      expect(response.isSuccess, true);
      expect(response.data, true);
    });

    test('should fail to create folder if folder already exists', () async {
      final response = await frappeStorageController.createFolder(
          folderName: existingFolder);

      expect(response.isSuccess, false);
      expect(response.error.info.httpCode, 409);
      expect(response.error.type, RenovationError.DuplicateEntryError);
      expect(response.error.title, 'Folder with same name exists');
    });

    tearDown(() async {
      await renovation.call(<String, dynamic>{
        'cmd': 'frappe.desk.reportview.delete_items',
        'doctype': 'File',
        'items': jsonEncode(['Home/$newFolder'])
      });
    });
  });

  group('uploadViaHTTP', () {
    test('should upload file successfully', () async {
      final response = await frappeStorageController.uploadViaHTTP(
          FrappeUploadFileParams(
              file: File(path.absolute('test/assets/sample.txt')),
              fileName: 'sample.txt'));

      expect(response.isSuccess, true);
      expect(response.data.fileName, 'sample.txt');
      expect(response.data.fileUrl.contains('sample'), true);
    });

    test('should upload file successfully as a private file', () async {
      final response = await frappeStorageController.uploadViaHTTP(
          FrappeUploadFileParams(
              file: File(path.absolute('test/assets/sample.txt')),
              fileName: 'sample.txt',
              isPrivate: true));

      expect(response.isSuccess, true);
      expect(response.data.isPrivate, true);
      expect(response.data.fileUrl.contains('sample'), true);
    });
  });

  group('uploadFile (Socket.io)', () {
    test('should upload successfully', () async {
      // A 512 KB will be divided into 21 chunks
      // So we generate a list of uploading status (21 of them) and concluded by a .completedStatus

      final statusProgress =
          List<UploadingStatus>.generate(21, (i) => UploadingStatus.uploading);

      statusProgress.add(UploadingStatus.completed);

      final file = File(path.absolute('test/assets/socketio_image.jpg'));
      await expectLater(
          frappeStorageController
              .uploadFile(FrappeUploadFileParams(
                  file: file, fileName: 'socketio_upload_test'))
              .stream
              .map((s) => s.status),
          emitsInOrder(statusProgress));
    });
  });

  tearDownAll(() async => await getFrappeAuthController().logout());
}
