import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vg_coffee/coffee/coffee.dart';

part 'coffee_event.dart';
part 'coffee_state.dart';

class CoffeeBloc extends Bloc<CoffeeEvent, CoffeeState> {
  CoffeeBloc(this._coffeeRepository) : super(const CoffeeState()) {
    on<CoffeeImageFavoriteStatusChanged>(_onFavoriteStatusChanged);
    on<CoffeeImageRequested>(_onCoffeeImageRequested);
  }

  final CoffeeRepository _coffeeRepository;

  FutureOr<void> _onFavoriteStatusChanged(
    CoffeeImageFavoriteStatusChanged event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.favoritingImage));

    try {
      if (event.isFavorite == true) {
        await _coffeeRepository.saveCoffeeImage(
          bytes: state.image!.bytes,
          filename: state.image!.filename,
        );
      } else {
        await _coffeeRepository.deleteCoffeeImage(state.image!.filename);
      }

      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          image: state.image?.copyWith(isFavorite: event.isFavorite),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CoffeeStatus.errorSavingOrDeletingImage));
    }
  }

  FutureOr<void> _onCoffeeImageRequested(
    CoffeeImageRequested event,
    Emitter<CoffeeState> emit,
  ) async {
    emit(state.copyWith(status: CoffeeStatus.loadingImage));

    try {
      final image = await _coffeeRepository.fetchCoffeeImage();
      emit(
        state.copyWith(
          status: CoffeeStatus.success,
          image: Image(
            isFavorite: false,
            filename: image.filename,
            bytes: image.bytes,
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: CoffeeStatus.errorFetchingImage));
    }
  }
}
