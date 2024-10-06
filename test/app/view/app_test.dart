import 'package:flutter_test/flutter_test.dart';
import 'package:vg_coffee/app/app.dart';
import 'package:vg_coffee/coffee/coffee.dart';

void main() {
  group('App', () {
    testWidgets('renders CoffeeScreen', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CoffeeScreen), findsOneWidget);
    });
  });
}
