import 'package:flutter_test/flutter_test.dart';
import 'package:vg_coffee/coffee/coffee.dart';
import 'package:vg_coffee/core/common_libs.dart';
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
  });
}
