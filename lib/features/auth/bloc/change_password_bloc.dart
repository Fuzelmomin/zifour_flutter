import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/change_password_repository.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/user_preference.dart';
import '../../../core/utils/connectivity_helper.dart';

// Change Password BLoC Events
abstract class ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  
  ChangePasswordSubmitted({
    required this.oldPassword,
    required this.newPassword,
  });
}

// Change Password BLoC States
abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;
  ChangePasswordSuccess({required this.message});
}

class ChangePasswordError extends ChangePasswordState {
  final String message;
  ChangePasswordError(this.message);
}

