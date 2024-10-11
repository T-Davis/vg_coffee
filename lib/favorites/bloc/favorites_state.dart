part of 'favorites_bloc.dart';

enum FavoritesStatus {
  initial,
  success,
  loading,
  error,
}

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.images = const [],
  });

  final FavoritesStatus status;
  final List<Image> images;

  @override
  List<Object> get props => [status, images];

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<Image>? images,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      images: images ?? this.images,
    );
  }
}
