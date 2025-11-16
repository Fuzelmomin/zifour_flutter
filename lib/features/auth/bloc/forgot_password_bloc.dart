import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/forgot_password_repository.dart';
import '../../../core/api_models/api_status.dart';

// Forgot Password BLoC Events
abstract class ForgotPasswordEvent {}

class SendForgotPasswordOTP extends ForgotPasswordEvent {
  final String mobile;
  SendForgotPasswordOTP(this.mobile);
}

// Forgot Password BLoC States
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordOTPSent extends ForgotPasswordState {
  final String mobile;
  final String message;
  
  ForgotPasswordOTPSent({
    required this.mobile,
    required this.message,
  });
}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;
  ForgotPasswordError(this.message);
}

// Forgot Password BLoC
class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<SendForgotPasswordOTP>(_onSendForgotPasswordOTP);
  }

  Future<void> _onSendForgotPasswordOTP(
    SendForgotPasswordOTP event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());

    try {
      final response = await _repository.sendForgotPasswordOTP(
        mobile: event.mobile,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ForgotPasswordOTPSent(
          mobile: event.mobile,
          message: response.data!.message,
        ));
      } else {
        emit(ForgotPasswordError(
          response.errorMsg ?? 'Failed to send OTP',
        ));
      }
    } catch (e) {
      emit(ForgotPasswordError('Error: ${e.toString()}'));
    }
  }
}

