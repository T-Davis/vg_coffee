import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vg_coffee/app/app.dart';

void main() {
  late AppBloc appBloc;

  setUp(() {
    appBloc = AppBloc();
  });

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits nothing',
      build: () => appBloc,
      expect: () => const <AppState>[],
    );

    blocTest<AppBloc, AppState>(
      'emits selected index',
      build: () => appBloc,
      act: (bloc) => bloc.add(AppTabSelected(index: 1)),
      expect: () => const <AppState>[
        AppState(selectedTab: 1),
      ],
    );
  });
}
