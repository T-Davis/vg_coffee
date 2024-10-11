import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/coffee/models/image.dart' as c;
import 'package:vg_coffee/coffee/view/coffee_screen.dart';

import '../../helpers/helpers.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

const pngBytes = [
  255, 216, 255, 224, 0, 16, 74, 70, 73, 70, 0, 1, 1,
  1, 0, 72, 0, 72, 0, 0, 255, 219, 0, 67, 0, 3, 2, 2, 2, 2, 2, 3, 2, 2, 2, 3,
  3, 3, 3, 4, 6, 4, 4, 4, 4, 4, 8, 6, 6, 5, 6, 9, 8, 10, 10, 9, 8, 9, 9, 10,
  12, 15, 12, 10, 11, 14, 11, 9, 9, 13, 17, 13, 14, 15, 16, 16, 17, 16, 10,
  12, 18, 19, 18, 16, 19, 15, 16, 16, 16, 255, 201, 0, 11, 8, 0, 1, 0, 1, 1,
  1, 17, 0, 255, 204, 0, 6, 0, 16, 16, 5, 255, 218, 0, 8, 1, 1, 0, 0, 63, 0,
  210, 207, 32, 255, 217,
  // Commented to keep formatting.
];

void main() {
  late CoffeeBloc coffeeBloc;

  setUp(() {
    coffeeBloc = MockCoffeeBloc();
  });

  group('CoffeeImage', () {
    testWidgets('renders CircularProgressIndicator in initial state',
        (tester) async {
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator in loading state',
        (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.loading));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders Image with correct bytes in success state',
        (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders Icon.error in error state', (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.error));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });

  group('buttons', () {
    testWidgets(
        'Favorite button is disabled '
        'when status is not success or error', (tester) async {
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('favorite')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'Favorite button is enabled '
        'when status is success', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('favorite')))
            .onPressed,
        isNotNull,
      );
    });

    testWidgets(
        'Favorite button is disabled '
        'when status is initial', (tester) async {
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('favorite')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'Favorite button is disabled '
        'when status is loading', (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.loading));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('favorite')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'Favorite button is disabled '
        'when status is error', (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.error));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('favorite')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'Next button is enabled '
        'when status is success', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('next')))
            .onPressed,
        isNotNull,
      );
    });

    testWidgets(
        'Next button is enabled '
        'when status is error', (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.error));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('next')))
            .onPressed,
        isNotNull,
      );
    });

    testWidgets(
        'Next button is disabled '
        'when status is initial', (tester) async {
      when(() => coffeeBloc.state).thenReturn(const CoffeeState());

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('next')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'Next button is disabled '
        'when status is loading', (tester) async {
      when(() => coffeeBloc.state)
          .thenReturn(const CoffeeState(status: CoffeeStatus.loading));

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      expect(
        tester
            .widget<ElevatedButton>(find.byKey(const ValueKey('next')))
            .onPressed,
        isNull,
      );
    });

    testWidgets(
        'calls CoffeeImageFavoriteStatusChanged '
        'with correct value '
        'when Favorite button is pressed', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      await tester.tap(find.byKey(const ValueKey('favorite')));
      verify(
        () => coffeeBloc.add(
          CoffeeImageFavoriteStatusChanged(isFavorite: true),
        ),
      ).called(1);
    });

    testWidgets(
        'calls CoffeeImageRequested '
        'when Next button is pressed', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );
      await tester.tap(find.byKey(const ValueKey('next')));

      verify(() => coffeeBloc.add(CoffeeImageRequested())).called(1);
    });
  });

  group('favorite icon', () {
    testWidgets(
        'renders Icons.favorite_border '
        'when isFavorite is false', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: false,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      // Find the button by its key.
      final buttonFinder = find.byKey(const ValueKey('favorite'));
      expect(buttonFinder, findsOneWidget);

      // Find the Icon widget within the ElevatedButton.icon.
      final iconFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);

      // Get the Icon widget.
      final icon = tester.widget(iconFinder) as Icon;

      // Check that the icon has the correct icon data.
      expect(icon.icon, equals(Icons.favorite_border));
    });

    testWidgets(
        'renders Icons.favorite '
        'when isFavorite is true', (tester) async {
      when(() => coffeeBloc.state).thenReturn(
        CoffeeState(
          status: CoffeeStatus.success,
          image: c.Image(
            isFavorite: true,
            filename: 'image.png',
            bytes: Uint8List.fromList(pngBytes),
          ),
        ),
      );

      await tester.pumpApp(
        widget: const CoffeeScreen(),
        coffeeBloc: coffeeBloc,
      );

      // Find the button by its key.
      final buttonFinder = find.byKey(const ValueKey('favorite'));
      expect(buttonFinder, findsOneWidget);

      // Find the Icon widget within the ElevatedButton.icon.
      final iconFinder = find.descendant(
        of: buttonFinder,
        matching: find.byType(Icon),
      );
      expect(iconFinder, findsOneWidget);

      // Get the Icon widget.
      final icon = tester.widget(iconFinder) as Icon;

      // Check that the icon has the correct icon data.
      expect(icon.icon, equals(Icons.favorite));
    });
  });
}
