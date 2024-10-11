import 'dart:io';
import 'dart:typed_data';

import 'package:local_storage_api/local_storage_api.dart';
import 'package:path_provider/path_provider.dart' as p;

/// Exception thrown when saveImage fails.
class SaveImageFailure implements Exception {}

/// Exception thrown when getImages fails.
class GetImageFailure implements Exception {}

/// Exception thrown when deleteImage fails.
class DeleteImageFailure implements Exception {}

/// The directory to save images in.
const imageDirectory = 'images';

/// {@template local_storage_api}
/// Dart API Client for the local storage API, path_provider.
/// {@endtemplate}
class LocalStorageApi {
  /// {@macro local_storage_api}
  LocalStorageApi([
    Future<Directory> Function()? getApplicationDocumentsDirectory,
    File? file,
  ])  : _getApplicationDocumentsDirectory = getApplicationDocumentsDirectory ??
            p.getApplicationDocumentsDirectory,
        _file = file;

  // Top level function injected for testing.
  final Future<Directory> Function() _getApplicationDocumentsDirectory;
  final File? _file;

  /// Saves an image to local storage.
  ///
  /// [bytes] The image bytes to save.
  /// [filename] The name of the file to save the image to.
  Future<void> saveImage({
    required Uint8List bytes,
    required String filename,
  }) async {
    try {
      final directory = await _getLocalStorageDirectory();
      final filePath = '${directory.path}/$imageDirectory/$filename';
      final file = _file ?? await File(filePath).create(recursive: true);

      await file.writeAsBytes(bytes);
    } catch (e) {
      throw SaveImageFailure();
    }
  }

  /// Gets a list of images from local storage.
  ///
  /// Returns a list of [Image] objects.
  Future<List<Image>> getImages() async {
    try {
      final directory = await _getLocalStorageDirectory();
      final files = directory.listSync();
      final imagePaths = files.where((element) {
        return element.path.startsWith('/images/');
      }).toList();

      final images = <Image>[];

      for (final element in imagePaths) {
        final file = _file ?? File(element.path);
        final bytes = file.readAsBytesSync();
        images.add(Image(bytes: bytes, filename: file.path.split('/').last));
      }

      return images;
    } catch (e) {
      throw GetImageFailure();
    }
  }

  /// Deletes an image from local storage.
  ///
  /// [filename] The name of the file to delete.
  Future<void> deleteImage(String filename) async {
    try {
      final directory = await _getLocalStorageDirectory();
      final filePath = '${directory.path}/$imageDirectory/$filename';
      final file = _file ?? File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      throw DeleteImageFailure();
    }
  }

  Future<Directory> _getLocalStorageDirectory() async {
    final directory = await _getApplicationDocumentsDirectory();
    return directory;
  }
}
