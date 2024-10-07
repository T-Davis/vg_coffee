import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppTabSelected>(_onTabSelected);
  }

  FutureOr<void> _onTabSelected(
    AppTabSelected event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.index));
  }
}
