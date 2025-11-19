part of 'home_bloc.dart';

enum HomeStatus { initial, loading, refreshing, success, failure }

class HomeState {
  final HomeStatus status;
  final HomeResponse? data;
  final String? errorMessage;
  final DateTime? lastUpdated;

  const HomeState({
    required this.status,
    this.data,
    this.errorMessage,
    this.lastUpdated,
  });

  factory HomeState.initial() => const HomeState(status: HomeStatus.initial);

  bool get showSkeleton => status == HomeStatus.loading && data == null;
  bool get isRefreshing => status == HomeStatus.refreshing;

  HomeState copyWith({
    HomeStatus? status,
    HomeResponse? data,
    String? errorMessage,
    bool clearError = false,
    DateTime? lastUpdated,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

