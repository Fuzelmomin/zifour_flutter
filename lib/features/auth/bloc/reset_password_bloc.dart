import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/forgot_password_verification_repository.dart';
import '../../../core/api_models/api_status.dart';

// Reset Password BLoC Events
abstract class ResetPasswordEvent {}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String mobile;
  final String otp;
  final String password;
  ResetPasswordSubmitted({
    required this.mobile,
    required this.otp,
    required this.password,
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
  final ForgotPasswordVerificationRepository _repository = ForgotPasswordVerificationRepository();

  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoading());

    try {
      final response = await _repository.resetPassword(
        mobile: event.mobile,
        otp: event.otp,
        password: event.password,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ResetPasswordSuccess(
          message: response.data!.message,
        ));
      } else {
        emit(ResetPasswordError(
          response.errorMsg ?? 'Failed to reset password',
        ));
      }
    } catch (e) {
      emit(ResetPasswordError('Error: ${e.toString()}'));
    }
  }
}

