import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../models/home_model.dart';
import '../repository/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({HomeRepository? repository})
      : _repository = repository ?? HomeRepository(),
        super(HomeState.initial()) {
    on<HomeRequested>(_onRequested);
  }

  final HomeRepository _repository;
  DateTime? _lastFetchedAt;

  Future<void> _onRequested(
    HomeRequested event,
    Emitter<HomeState> emit,
  ) async {
    final now = DateTime.now();
    final isCacheValid = !event.forceRefresh &&
        _lastFetchedAt != null &&
        now.difference(_lastFetchedAt!) < const Duration(minutes: 5) &&
        state.data != null;

    if (isCacheValid) {
      _completeRefresh(event.completer);
      return;
    }

    final shouldShowRefreshingState =
        event.forceRefresh && state.data != null && state.status == HomeStatus.success;

    emit(
      state.copyWith(
        status: shouldShowRefreshingState ? HomeStatus.refreshing : HomeStatus.loading,
        clearError: true,
      ),
    );

    final response = await _repository.fetchHomeData();

    if (response.status == ApiStatus.success && response.data != null) {
      _lastFetchedAt = DateTime.now();
      emit(
        state.copyWith(
          status: HomeStatus.success,
          data: response.data,
          lastUpdated: _lastFetchedAt,
          clearError: true,
        ),
      );
      _completeRefresh(event.completer);
    } else {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: response.errorMsg ?? 'Unable to load home data.',
        ),
      );
      _completeRefresh(
        event.completer,
        response.errorMsg ?? 'Unable to load home data.',
      );
    }
  }

  void _completeRefresh(Completer<void>? completer, [String? error]) {
    if (completer == null || completer.isCompleted) {
      return;
    }
    if (error == null) {
      completer.complete();
    } else {
      completer.completeError(error);
    }
  }
}

