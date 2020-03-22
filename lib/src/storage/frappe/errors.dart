class FileTypeError extends Error {
  @override
  String toString() => 'File must be of type Uint8List or File (dart:io)';
}

class MissingFileError extends Error {
  @override
  String toString() => 'File is required to upload';
}

class MissingFileNameError extends Error {
  @override
  String toString() => 'File name is required';
}
