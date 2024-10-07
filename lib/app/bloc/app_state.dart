part of 'app_bloc.dart';

enum AppStatus {
  initial,
  success,
  loading,
}

class AppState extends Equatable {
  const AppState({
    this.status = AppStatus.initial,
    this.selectedTab = 0,
  });

  final AppStatus status;
  final int selectedTab;

  @override
  List<Object> get props => [
        status,
        selectedTab,
      ];

  AppState copyWith({
    AppStatus? status,
    int? selectedTab,
  }) {
    return AppState(
      status: status ?? this.status,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
