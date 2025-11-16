import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/forgot_password_verification_repository.dart';
import '../../../core/api_models/api_status.dart';

// Forgot Password Verification BLoC Events
abstract class ForgotPasswordVerificationEvent {}

class VerifyForgotPasswordOTP extends ForgotPasswordVerificationEvent {
  final String mobile;
  final String otp;
  VerifyForgotPasswordOTP({required this.mobile, required this.otp});
}

class ResendForgotPasswordOTP extends ForgotPasswordVerificationEvent {
  final String mobile;
  ResendForgotPasswordOTP(this.mobile);
}

class StartOTPTimer extends ForgotPasswordVerificationEvent {}

class UpdateOTPTimer extends ForgotPasswordVerificationEvent {}

// Forgot Password Verification BLoC States
abstract class ForgotPasswordVerificationState {
  final int otpResendTimer;
  ForgotPasswordVerificationState({this.otpResendTimer = 20});
}

class ForgotPasswordVerificationInitial extends ForgotPasswordVerificationState {
  ForgotPasswordVerificationInitial({super.otpResendTimer = 20});
}

class ForgotPasswordVerificationLoading extends ForgotPasswordVerificationState {
  ForgotPasswordVerificationLoading({super.otpResendTimer = 20});
}

class ForgotPasswordVerificationOTPVerified extends ForgotPasswordVerificationState {
  final String message;
  final String otp;
  ForgotPasswordVerificationOTPVerified({
    required this.message,
    required this.otp,
    super.otpResendTimer = 20,
  });
}

class ForgotPasswordVerificationOTPResent extends ForgotPasswordVerificationState {
  final String message;
  ForgotPasswordVerificationOTPResent({
    required this.message,
    super.otpResendTimer = 20,
  });
}

class ForgotPasswordVerificationError extends ForgotPasswordVerificationState {
  final String message;
  ForgotPasswordVerificationError({
    required this.message,
    super.otpResendTimer = 20,
  });
}

// Forgot Password Verification BLoC
class ForgotPasswordVerificationBloc extends Bloc<ForgotPasswordVerificationEvent, ForgotPasswordVerificationState> {
  final ForgotPasswordVerificationRepository _repository = ForgotPasswordVerificationRepository();
  Timer? _otpTimer;

  ForgotPasswordVerificationBloc() : super(ForgotPasswordVerificationInitial()) {
    on<VerifyForgotPasswordOTP>(_onVerifyForgotPasswordOTP);
    on<ResendForgotPasswordOTP>(_onResendForgotPasswordOTP);
    on<StartOTPTimer>(_onStartOTPTimer);
    on<UpdateOTPTimer>(_onUpdateOTPTimer);
    // Start timer when bloc is created
    _startCountdown();
  }

  Future<void> _onVerifyForgotPasswordOTP(
    VerifyForgotPasswordOTP event,
    Emitter<ForgotPasswordVerificationState> emit,
  ) async {
    emit(ForgotPasswordVerificationLoading(otpResendTimer: state.otpResendTimer));

    try {
      final response = await _repository.verifyForgotPasswordOTP(
        mobile: event.mobile,
        otp: event.otp,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        emit(ForgotPasswordVerificationOTPVerified(
          message: response.data!.message,
          otp: event.otp,
          otpResendTimer: state.otpResendTimer,
        ));
      } else {
        emit(ForgotPasswordVerificationError(
          message: response.errorMsg ?? 'Failed to verify OTP',
          otpResendTimer: state.otpResendTimer,
        ));
      }
    } catch (e) {
      emit(ForgotPasswordVerificationError(
        message: 'Error: ${e.toString()}',
        otpResendTimer: state.otpResendTimer,
      ));
    }
  }

  Future<void> _onResendForgotPasswordOTP(
    ResendForgotPasswordOTP event,
    Emitter<ForgotPasswordVerificationState> emit,
  ) async {
    final currentTimer = state.otpResendTimer;
    
    try {
      final response = await _repository.resendForgotPasswordOTP(
        mobile: event.mobile,
      );

      if (response.status == ApiStatus.success && response.data != null) {
        // Reset timer to 20 seconds
        emit(ForgotPasswordVerificationOTPResent(
          message: response.data!.message,
          otpResendTimer: 20,
        ));
        // Start countdown timer
        _startCountdown();
      } else {
        emit(ForgotPasswordVerificationError(
          message: response.errorMsg ?? 'Failed to resend OTP',
          otpResendTimer: currentTimer,
        ));
      }
    } catch (e) {
      emit(ForgotPasswordVerificationError(
        message: 'Error: ${e.toString()}',
        otpResendTimer: currentTimer,
      ));
    }
  }

  void _onStartOTPTimer(StartOTPTimer event, Emitter<ForgotPasswordVerificationState> emit) {
    if (state is ForgotPasswordVerificationInitial || 
        state is ForgotPasswordVerificationError ||
        state is ForgotPasswordVerificationOTPResent) {
      _startCountdown();
    }
  }

  void _onUpdateOTPTimer(UpdateOTPTimer event, Emitter<ForgotPasswordVerificationState> emit) {
    if (state.otpResendTimer > 0) {
      final newTimer = state.otpResendTimer - 1;
      
      if (state is ForgotPasswordVerificationOTPResent) {
        final currentState = state as ForgotPasswordVerificationOTPResent;
        emit(ForgotPasswordVerificationOTPResent(
          message: currentState.message,
          otpResendTimer: newTimer,
        ));
      } else if (state is ForgotPasswordVerificationInitial) {
        emit(ForgotPasswordVerificationInitial(otpResendTimer: newTimer));
      } else if (state is ForgotPasswordVerificationError) {
        final currentState = state as ForgotPasswordVerificationError;
        emit(ForgotPasswordVerificationError(
          message: currentState.message,
          otpResendTimer: newTimer,
        ));
      } else if (state is ForgotPasswordVerificationLoading) {
        // Keep loading state but update timer
        emit(ForgotPasswordVerificationLoading(otpResendTimer: newTimer));
      }
      
      if (newTimer == 0) {
        _otpTimer?.cancel();
      }
    } else {
      _otpTimer?.cancel();
    }
  }

  void _startCountdown() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      add(UpdateOTPTimer());
    });
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}

