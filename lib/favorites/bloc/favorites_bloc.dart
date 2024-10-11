import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_repository/coffee_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:vg_coffee/favorites/favorites.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this._coffeeRepository) : super(const FavoritesState()) {
    on<FavoritesLoadImagesRequested>(_onLoadImagesRequested);
    on<FavoritesAddImageRequested>(_onAddImageRequested);
    on<FavoritesRemoveImageRequested>(_onRemoveImageRequested);
  }

  final CoffeeRepository _coffeeRepository;

  Future<void> _onLoadImagesRequested(
    FavoritesLoadImagesRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final repoImages = await _coffeeRepository.getCoffeeImages();
      final images = repoImages.map((image) {
        return Image(
          filename: image.filename,
          bytes: image.bytes,
        );
      }).toList();

      emit(
        state.copyWith(
          status: FavoritesStatus.success,
          images: images,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.error));
    }
  }

  FutureOr<void> _onAddImageRequested(
    FavoritesAddImageRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final images = List<Image>.from(state.images)
      ..add(
        Image(
          filename: event.filename,
          bytes: event.bytes,
        ),
      );

    emit(
      state.copyWith(
        status: FavoritesStatus.success,
        images: images,
      ),
    );
  }

  FutureOr<void> _onRemoveImageRequested(
    FavoritesRemoveImageRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final images = List<Image>.from(state.images)
      ..removeWhere((image) => image.filename == event.filename);

    emit(
      state.copyWith(
        status: FavoritesStatus.success,
        images: images,
      ),
    );
  }
}
