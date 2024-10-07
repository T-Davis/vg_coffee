part of 'app_bloc.dart';

@immutable
sealed class AppEvent extends Equatable {}

class AppTabSelected extends AppEvent {
  AppTabSelected({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}
