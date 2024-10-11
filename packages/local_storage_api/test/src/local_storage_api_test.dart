import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_api/local_storage_api.dart';
import 'package:mocktail/mocktail.dart';

class MockDirectory extends Mock implements Directory {}

class MockFile extends Mock implements File {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageApi', () {
    late LocalStorageApi localStorageApi;
    late Directory directory;
    late File file;

    setUp(() {
      directory = MockDirectory();
      file = MockFile();
      Future<Directory> getApplicationDocumentsDirectory() async {
        return directory;
      }

      localStorageApi = LocalStorageApi(getApplicationDocumentsDirectory, file);
    });

    group('saveImage', () {
      test('saves image to local storage', () async {
        const filename = 'test.png';
        final bytes = Uint8List.fromList([1, 2, 3]);
        when(() => directory.path).thenReturn('test/path');
        when(() => file.writeAsBytes(bytes)).thenAnswer((_) async => file);

        await localStorageApi.saveImage(
          bytes: bytes,
          filename: filename,
        );

        verify(() => file.writeAsBytes(bytes)).called(1);
      });

      test('throws SaveImageFailure on error', () async {
        const filename = 'test.png';
        final bytes = Uint8List.fromList([1, 2, 3]);
        when(() => directory.path).thenReturn('test/path');

        expect(
          () async => localStorageApi.saveImage(
            bytes: bytes,
            filename: filename,
          ),
          throwsA(isA<SaveImageFailure>()),
        );
      });
    });

    group('getImages', () {
      test('gets images from local storage', () async {
        final imageFile1 = file;
        final imageFile2 = file;
        when(directory.listSync).thenReturn([
          imageFile1,
          imageFile2,
        ]);
        when(() => imageFile1.path).thenReturn('/images/test1.png');
        when(() => imageFile2.path).thenReturn('/images/test2.png');
        when(imageFile1.readAsBytesSync)
            .thenReturn(Uint8List.fromList([1, 2, 3]));
        when(imageFile2.readAsBytesSync)
            .thenReturn(Uint8List.fromList([4, 5, 6]));

        final images = await localStorageApi.getImages();

        // We can not check that the images are different because only one file
        // [file] is injected into the api, thus the files will be the same
        // instance and will have the second method-call's parameters.
        expect(images, hasLength(2));
      });

      test('throws GetImageFailure on error', () async {
        when(directory.listSync).thenThrow(Exception());

        expect(
          () async => localStorageApi.getImages(),
          throwsA(isA<GetImageFailure>()),
        );
      });
    });

    group('deleteImage', () {
      test('deletes image from local storage', () async {
        const filename = 'test.png';
        when(() => directory.path).thenReturn('test/path');
        when(file.existsSync).thenReturn(true);
        when(file.delete).thenAnswer((_) async => file);

        await localStorageApi.deleteImage(filename);

        verify(file.delete).called(1);
      });

      test('does nothing if file does not exist', () async {
        const filename = 'test.png';
        when(() => directory.path).thenReturn('test/path');
        when(file.existsSync).thenReturn(false);
        when(file.delete).thenAnswer((_) async => file);

        await localStorageApi.deleteImage(filename);

        verifyNever(file.delete);
      });

      test('throws DeleteImageFailure on error', () async {
        const filename = 'test.png';
        when(() => directory.path).thenReturn('test/path');
        when(file.existsSync).thenReturn(true);
        when(file.delete).thenThrow(Exception());

        expect(
          () async => localStorageApi.deleteImage(filename),
          throwsA(isA<DeleteImageFailure>()),
        );
      });
    });
  });
}
