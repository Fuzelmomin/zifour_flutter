import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/reset_password_repository.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/user_preference.dart';
import '../../../core/utils/connectivity_helper.dart';

// Reset Password BLoC Events
abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String oldPassword;
  final String newPassword;
  
  ResetPasswordSubmitted({
    required this.oldPassword,
    required this.newPassword,
  });
}

// Reset Password BLoC States
abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;
  ResetPasswordSuccess({required this.message});
}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  ResetPasswordError(this.message);
}

// Reset Password BLoC
class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ResetPasswordRepository _repository = ResetPasswordRepository();

  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    // Check internet connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      emit(ResetPasswordError('No internet connection. Please check your network and try again.'));
      return;
    }

    emit(ResetPasswordLoading());

    try {
      // Get current user data
      final userData = await UserPreference.getUserData();
      if (userData == null || userData.stuId.isEmpty) {
        emit(ResetPasswordError('User data not found. Please login again.'));
        return;
      }

      final response = await _repository.changePassword(
        stuId: userData.stuId,
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ResetPasswordSuccess(
          message: response.data!.message,
        ));
      } else {
        emit(ResetPasswordError(
          response.errorMsg ?? 'Failed to change password',
        ));
      }
    } catch (e) {
      emit(ResetPasswordError('Error: ${e.toString()}'));
    }
  }
}

