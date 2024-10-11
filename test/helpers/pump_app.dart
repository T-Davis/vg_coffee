import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vg_coffee/app/bloc/app_bloc.dart';
import 'package:vg_coffee/coffee/bloc/coffee_bloc.dart';
import 'package:vg_coffee/favorites/bloc/favorites_bloc.dart';
import 'package:vg_coffee/l10n/l10n.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockCoffeeBloc extends MockBloc<CoffeeEvent, CoffeeState>
    implements CoffeeBloc {}

class MockFavoritesBloc extends MockBloc<FavoritesEvent, FavoritesState>
    implements FavoritesBloc {}

class MockCoffeeRepository extends Mock implements CoffeeRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp({
    required Widget widget,
    AppBloc? appBloc,
    CoffeeBloc? coffeeBloc,
    FavoritesBloc? favoritesBloc,
  }) {
    return pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: appBloc ?? MockAppBloc(),
          ),
          BlocProvider.value(
            value: coffeeBloc ?? MockCoffeeBloc(),
          ),
          BlocProvider.value(
            value: favoritesBloc ?? MockFavoritesBloc(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
