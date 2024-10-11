part of 'favorites_bloc.dart';

@immutable
sealed class FavoritesEvent extends Equatable {}

class FavoritesLoadImagesRequested extends FavoritesEvent {
  FavoritesLoadImagesRequested();

  @override
  List<Object?> get props => [];
}

class FavoritesAddImageRequested extends FavoritesEvent {
  FavoritesAddImageRequested({
    required this.filename,
    required this.bytes,
  });

  final String filename;
  final Uint8List bytes;

  @override
  List<Object?> get props => [filename, bytes];
}

class FavoritesRemoveImageRequested extends FavoritesEvent {
  FavoritesRemoveImageRequested(this.filename);

  final String filename;

  @override
  List<Object?> get props => [filename];
}
