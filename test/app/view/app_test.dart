import 'package:flutter_test/flutter_test.dart';
import 'package:vg_coffee/coffee/coffee.dart';
import 'package:vg_coffee/core/core.dart';
import 'package:vg_coffee/favorites/favorites.dart';

import '../../helpers/helpers.dart';

void main() {
  group('App', () {
    testWidgets('renders CoffeeScreen', (tester) async {
      await tester.pumpApp(
        widget: App(coffeeRepository: MockCoffeeRepository()),
      );

      expect(find.byType(CoffeeScreen), findsOneWidget);
      expect(find.byType(FavoritesScreen), findsNothing);
    });

    testWidgets('renders BottomNavigationBar', (tester) async {
      await tester.pumpApp(
        widget: App(coffeeRepository: MockCoffeeRepository()),
      );

      final bottomNavWidget = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );

      expect(bottomNavWidget.currentIndex, 0);
      expect(find.byIcon(Icons.coffee), findsOne);
      expect(find.byIcon(Icons.favorite), findsOne);
    });

    testWidgets('renders FavoritesScreen after navigation', (tester) async {
      await tester.pumpApp(
        widget: App(coffeeRepository: MockCoffeeRepository()),
      );
      // Navigate to FavoritesScreen.
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      expect(find.byType(FavoritesScreen), findsOneWidget);
      expect(find.byType(CoffeeScreen), findsNothing);
    });

    testWidgets('renders CoffeeScreen after navigation', (tester) async {
      await tester.pumpApp(
        widget: App(coffeeRepository: MockCoffeeRepository()),
      );
      // Navigate to FavoritesScreen.
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      // Navigate to CoffeeScreen.
      await tester.tap(find.byIcon(Icons.coffee));
      await tester.pumpAndSettle();

      expect(find.byType(CoffeeScreen), findsOneWidget);
      expect(find.byType(FavoritesScreen), findsNothing);
    });

    // TODO(t-davis): Fix these tests
    // group('CoffeeBloc Listener', () {
    //   late CoffeeBloc coffeeBloc;
    //   late FavoritesBloc favoritesBloc;

    //   setUp(() {
    //     coffeeBloc = MockCoffeeBloc();
    //     favoritesBloc = MockFavoritesBloc();
    //   });

    // testWidgets(
    //     'adds FavoritesAddImageRequested to FavoritesBloc '
    //     'when CoffeeBloc updates with isFavorite: true', (tester) async {
    //   whenListen(
    //     coffeeBloc,
    //     const Stream<CoffeeState>.empty(),
    //     initialState: const CoffeeState(),
    //   );
    //   whenListen(
    //     favoritesBloc,
    //     const Stream<FavoritesState>.empty(),
    //     initialState: const FavoritesState(),
    //   );
    //   await tester.pumpApp(
    //     widget: App(coffeeRepository: MockCoffeeRepository()),
    //     coffeeBloc: coffeeBloc,
    //     favoritesBloc: favoritesBloc,
    //   );

    //   coffeeBloc
    //     ..emit(
    //       CoffeeState(
    //         status: CoffeeStatus.favoritingImage,
    //         image: c.Image(
    //           filename: 'filename.jpg',
    //           bytes: Uint8List.fromList([]),
    //           isFavorite: false,
    //         ),
    //       ),
    //     )
    //     ..emit(
    //       CoffeeState(
    //         status: CoffeeStatus.success,
    //         image: c.Image(
    //           filename: 'filename.jpg',
    //           bytes: Uint8List.fromList([]),
    //           isFavorite: true,
    //         ),
    //       ),
    //     );
    //   await tester.pump();

    //   verify(
    //     () => favoritesBloc.add(
    //       FavoritesAddImageRequested(
    //         filename: 'filename.jpg',
    //         bytes: Uint8List.fromList([]),
    //       ),
    //     ),
    //   ).called(1);
    // });

    // testWidgets(
    //     'adds FavoritesRemoveImageRequested to FavoritesBloc '
    //     'when CoffeeBloc updates with isFavorite: false', (tester) async {
    //   whenListen(
    //     coffeeBloc,
    //     const Stream<CoffeeState>.empty(),
    //     initialState: const CoffeeState(),
    //   );
    //   whenListen(
    //     favoritesBloc,
    //     const Stream<FavoritesState>.empty(),
    //     initialState: const FavoritesState(),
    //   );
    //   await tester.pumpApp(
    //     widget: App(coffeeRepository: MockCoffeeRepository()),
    //     coffeeBloc: coffeeBloc,
    //     favoritesBloc: favoritesBloc,
    //   );

    //   coffeeBloc
    //     ..emit(
    //       CoffeeState(
    //         status: CoffeeStatus.favoritingImage,
    //         image: c.Image(
    //           filename: 'filename.jpg',
    //           bytes: Uint8List.fromList([]),
    //           isFavorite: true,
    //         ),
    //       ),
    //     )
    //     ..emit(
    //       CoffeeState(
    //         status: CoffeeStatus.success,
    //         image: c.Image(
    //           filename: 'filename.jpg',
    //           bytes: Uint8List.fromList([]),
    //           isFavorite: false,
    //         ),
    //       ),
    //     );
    //   await tester.pump();

    //   verify(
    //     () => favoritesBloc.add(
    //       FavoritesRemoveImageRequested('filename.jpg'),
    //     ),
    //   ).called(1);
    // });
    // });
  });
}
