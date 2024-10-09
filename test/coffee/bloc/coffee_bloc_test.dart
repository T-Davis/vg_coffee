import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/coffee/models/image.dart' as c;

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

void main() {
  late CoffeeRepository coffeeRepository;

  setUp(() {
    coffeeRepository = MockCoffeeRepository();
  });

  group('CoffeeBloc', () {
    test('initial state is CoffeeState()', () {
      expect(
        CoffeeBloc(coffeeRepository).state,
        equals(const CoffeeState()),
      );
    });

    group('CoffeeImageFavoriteStatusChanged', () {
      blocTest<CoffeeBloc, CoffeeState>(
        'emits updated image with isFavorite set to event.isFavorite',
        build: () => CoffeeBloc(coffeeRepository),
        seed: () => CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            imageType: 'png',
            bytes: Uint8List.fromList([]),
          ),
        ),
        act: (bloc) => bloc.add(
          CoffeeImageFavoriteStatusChanged(isFavorite: true),
        ),
        expect: () => <CoffeeState>[
          CoffeeState(
            status: CoffeeStatus.success,
            image: c.Image(
              isFavorite: true,
              imageType: 'png',
              bytes: Uint8List.fromList([]),
            ),
          ),
        ],
      );
    });

    group('CoffeeImageRequested', () {
      blocTest<CoffeeBloc, CoffeeState>(
        'emits [loading, success] '
        'when coffee image request is successful',
        setUp: () {
          when(() => coffeeRepository.fetchCoffeeImage()).thenAnswer(
            (_) async => CoffeeImage(
              imageType: 'png',
              bytes: Uint8List.fromList([]),
            ),
          );
        },
        build: () => CoffeeBloc(coffeeRepository),
        act: (bloc) => bloc.add(CoffeeImageRequested()),
        expect: () => <CoffeeState>[
          const CoffeeState(status: CoffeeStatus.loading),
          CoffeeState(
            status: CoffeeStatus.success,
            image: c.Image(
              isFavorite: false,
              imageType: 'png',
              bytes: Uint8List.fromList([]),
            ),
          ),
        ],
      );

      blocTest<CoffeeBloc, CoffeeState>(
        'emits [loading, error] '
        'when coffee image request fails',
        setUp: () {
          when(() => coffeeRepository.fetchCoffeeImage()).thenThrow(
            Exception('oops'),
          );
        },
        build: () => CoffeeBloc(coffeeRepository),
        act: (bloc) => bloc.add(CoffeeImageRequested()),
        expect: () => <CoffeeState>[
          const CoffeeState(status: CoffeeStatus.loading),
          const CoffeeState(status: CoffeeStatus.error),
        ],
      );
    });
  });
}
