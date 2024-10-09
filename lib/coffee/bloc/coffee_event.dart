part of 'coffee_bloc.dart';

@immutable
sealed class CoffeeEvent extends Equatable {}

class CoffeeImageFavoriteStatusChanged extends CoffeeEvent {
  CoffeeImageFavoriteStatusChanged({required this.isFavorite});

  final bool isFavorite;

  @override
  List<Object> get props => [isFavorite];
}

class CoffeeImageRequested extends CoffeeEvent {
  CoffeeImageRequested();

  @override
  List<Object> get props => [];
}
