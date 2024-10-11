import 'dart:typed_data';

import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:alex_flipnote_coffee_api/src/models/image.dart' as a;
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_storage_api/local_storage_api.dart';
import 'package:local_storage_api/src/models/image.dart' as l;
import 'package:mocktail/mocktail.dart';

class MockAlexFlipnoteCoffeeApiClient extends Mock
    implements AlexFlipnoteCoffeeApiClient {}

class MockLocalStorageApi extends Mock implements LocalStorageApi {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CoffeeRepository', () {
    late AlexFlipnoteCoffeeApiClient coffeeApiClient;
    late LocalStorageApi localStorageApi;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeApiClient = MockAlexFlipnoteCoffeeApiClient();
      localStorageApi = MockLocalStorageApi();
      coffeeRepository = CoffeeRepository(
        coffeeApiClient: coffeeApiClient,
        localStorageApi: localStorageApi,
      );
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(CoffeeRepository(), isNotNull);
      });
    });

    group('fetchCoffeeImage', () {
      final image = a.Image(
        filename: 'image.png',
        bytes: Uint8List.fromList([1, 2, 3]),
      );

      test('calls fetchRandomImage', () async {
        when(() => coffeeApiClient.fetchRandomImage())
            .thenAnswer((_) async => image);

        await coffeeRepository.fetchCoffeeImage();

        verify(() => coffeeApiClient.fetchRandomImage()).called(1);
      });

      test('returns correct data', () async {
        when(() => coffeeApiClient.fetchRandomImage())
            .thenAnswer((_) async => image);

        final actual = await coffeeRepository.fetchCoffeeImage();

        expect(
          actual,
          isA<CoffeeImage>()
              .having((i) => i.filename, 'filename', 'image.png')
              .having((i) => i.bytes, 'bytes', [1, 2, 3]),
        );
      });
    });

    group('saveCoffeeImage', () {
      test('calls saveImage', () async {
        const filename = 'test.png';
        final bytes = Uint8List.fromList([1, 2, 3]);
        when(
          () => localStorageApi.saveImage(
            bytes: bytes,
            filename: filename,
          ),
        ).thenAnswer((_) async {});

        await coffeeRepository.saveCoffeeImage(
          bytes: bytes,
          filename: filename,
        );

        verify(
          () => localStorageApi.saveImage(
            bytes: bytes,
            filename: filename,
          ),
        ).called(1);
      });
    });

    group('deleteCoffeeImage', () {
      test('calls deleteImage', () async {
        const filename = 'test.png';
        when(() => localStorageApi.deleteImage(filename))
            .thenAnswer((_) async {});

        await coffeeRepository.deleteCoffeeImage(filename);

        verify(() => localStorageApi.deleteImage(filename)).called(1);
      });
    });

    group('getCoffeeImages', () {
      final images = [
        l.Image(
          filename: 'test1.png',
          bytes: Uint8List.fromList([1, 2, 3]),
        ),
        l.Image(
          filename: 'test2.png',
          bytes: Uint8List.fromList([1, 2, 3, 4]),
        ),
      ];

      test('calls getImages', () async {
        when(() => localStorageApi.getImages()).thenAnswer((_) async => images);

        await coffeeRepository.getCoffeeImages();

        verify(() => localStorageApi.getImages()).called(1);
      });

      test('returns correct data', () async {
        when(() => localStorageApi.getImages()).thenAnswer((_) async => images);

        final actual = await coffeeRepository.getCoffeeImages();

        expect(
          actual,
          [
            isA<CoffeeImage>()
                .having((i) => i.filename, 'filename', 'test1.png')
                .having((i) => i.bytes, 'bytes', [1, 2, 3]),
            isA<CoffeeImage>()
                .having((i) => i.filename, 'filename', 'test2.png')
                .having((i) => i.bytes, 'bytes', [1, 2, 3, 4]),
          ],
        );
      });
    });
  });
}
