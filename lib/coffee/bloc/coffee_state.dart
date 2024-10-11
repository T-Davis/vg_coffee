part of 'coffee_bloc.dart';

enum CoffeeStatus {
  initial,
  success,
  loadingImage,
  favoritingImage,
  error,
}

class CoffeeState extends Equatable {
  const CoffeeState({
    this.status = CoffeeStatus.initial,
    this.image,
  });

  final CoffeeStatus status;
  final Image? image;

  @override
  List<Object?> get props => [
        status,
        image,
      ];

  CoffeeState copyWith({
    CoffeeStatus? status,
    Image? image,
  }) {
    return CoffeeState(
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }
}
