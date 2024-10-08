import 'dart:typed_data';

import 'package:alex_flipnote_coffee_api/alex_flipnote_coffee_api.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAlexFlipnoteCoffeeApiClient extends Mock
    implements AlexFlipnoteCoffeeApiClient {}

void main() {
  group('CoffeeRepository', () {
    late AlexFlipnoteCoffeeApiClient coffeeApiClient;
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeApiClient = MockAlexFlipnoteCoffeeApiClient();
      coffeeRepository = CoffeeRepository(coffeeApiClient: coffeeApiClient);
    });

    group('constructor', () {
      test('can be instantiated', () {
        expect(CoffeeRepository(), isNotNull);
      });
    });

    group('fetchCoffeeImage', () {
      final image = Image(
        imageType: 'png',
        bytes: Uint8List.fromList([1, 2, 3]),
      );

      test('calls fetchRandomImage', () async {
        when(() => coffeeApiClient.fetchRandomImage())
            .thenAnswer((_) async => image);
        try {
          await coffeeRepository.fetchCoffeeImage();
        } catch (_) {}
        verify(() => coffeeApiClient.fetchRandomImage()).called(1);
      });

      test('returns correct data', () async {
        when(() => coffeeApiClient.fetchRandomImage())
            .thenAnswer((_) async => image);
        final actual = await coffeeRepository.fetchCoffeeImage();
        expect(
          actual,
          isA<CoffeeImage>()
              .having((i) => i.imageType, 'imageType', 'png')
              .having((i) => i.bytes, 'bytes', [1, 2, 3]),
        );
      });
    });
  });
}
