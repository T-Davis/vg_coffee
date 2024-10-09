import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/l10n/l10n.dart';

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

extension PumpCoffee on WidgetTester {
  Future<void> pumpCoffee({
    required Widget widget,
    CoffeeBloc? coffeeBloc,
  }) {
    return pumpWidget(
      BlocProvider.value(
        value: coffeeBloc ?? MockCoffeeBloc(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
