part of 'doubts_list_bloc.dart';

abstract class DoubtsListState {}

class DoubtsListInitial extends DoubtsListState {}

class DoubtsListLoading extends DoubtsListState {}

class DoubtsListSuccess extends DoubtsListState {
  final DoubtsListResponse data;

  DoubtsListSuccess(this.data);
}

class DoubtsListError extends DoubtsListState {
  final String message;

  DoubtsListError(this.message);
}

