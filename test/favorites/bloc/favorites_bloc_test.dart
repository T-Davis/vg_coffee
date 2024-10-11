import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vg_coffee/favorites/favorites.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FavoritesBloc', () {
    late CoffeeRepository coffeeRepository;

    setUp(() {
      coffeeRepository = MockCoffeeRepository();
    });

    test('initial state is FavoritesState', () {
      expect(
        FavoritesBloc(coffeeRepository).state,
        const FavoritesState(),
      );
    });

    group('FavoritesLoadImagesRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'emits [loading, success] with images '
        'when coffee repository returns images successfully',
        setUp: () {
          when(
            () => coffeeRepository.getCoffeeImages(),
          ).thenAnswer(
            (_) async => [
              CoffeeImage(
                filename: 'filename.jpg',
                bytes: Uint8List.fromList([]),
              ),
            ],
          );
        },
        build: () => FavoritesBloc(coffeeRepository),
        act: (bloc) => bloc.add(FavoritesLoadImagesRequested()),
        expect: () => <FavoritesState>[
          const FavoritesState(status: FavoritesStatus.loading),
          FavoritesState(
            status: FavoritesStatus.success,
            images: [
              Image(
                filename: 'filename.jpg',
                bytes: Uint8List.fromList([]),
              ),
            ],
          ),
        ],
      );

      blocTest<FavoritesBloc, FavoritesState>(
        'emits [loading, error] when coffee repository throws an exception',
        setUp: () {
          when(
            () => coffeeRepository.getCoffeeImages(),
          ).thenThrow(Exception('oops'));
        },
        build: () => FavoritesBloc(coffeeRepository),
        act: (bloc) => bloc.add(FavoritesLoadImagesRequested()),
        expect: () => <FavoritesState>[
          const FavoritesState(status: FavoritesStatus.loading),
          const FavoritesState(status: FavoritesStatus.error),
        ],
      );
    });

    group('FavoritesAddImageRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'adds image to state',
        build: () => FavoritesBloc(coffeeRepository),
        act: (bloc) => bloc.add(
          FavoritesAddImageRequested(
            filename: 'filename.jpg',
            bytes: Uint8List.fromList([]),
          ),
        ),
        expect: () => <FavoritesState>[
          FavoritesState(
            status: FavoritesStatus.success,
            images: [
              Image(
                filename: 'filename.jpg',
                bytes: Uint8List.fromList([]),
              ),
            ],
          ),
        ],
      );
    });

    group('FavoritesRemoveImageRequested', () {
      blocTest<FavoritesBloc, FavoritesState>(
        'removes image from state',
        build: () => FavoritesBloc(coffeeRepository),
        seed: () => FavoritesState(
          status: FavoritesStatus.success,
          images: [
            Image(
              filename: 'filename.jpg',
              bytes: Uint8List.fromList([]),
            ),
          ],
        ),
        act: (bloc) => bloc.add(
          FavoritesRemoveImageRequested('filename.jpg'),
        ),
        expect: () => const <FavoritesState>[
          FavoritesState(status: FavoritesStatus.success),
        ],
      );
    });
  });
}
