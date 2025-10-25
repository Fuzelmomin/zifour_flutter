import 'package:flutter_bloc/flutter_bloc.dart';

// Signup BLoC Events
abstract class SignupEvent {}

class SignupInitialized extends SignupEvent {}

class UpdateFullName extends SignupEvent {
  final String fullName;
  UpdateFullName(this.fullName);
}

class UpdateStandard extends SignupEvent {
  final String standard;
  UpdateStandard(this.standard);
}

class UpdateCourse extends SignupEvent {
  final String course;
  UpdateCourse(this.course);
}

class UpdateGender extends SignupEvent {
  final String gender;
  UpdateGender(this.gender);
}

class UpdateMobileNumber extends SignupEvent {
  final String mobileNumber;
  UpdateMobileNumber(this.mobileNumber);
}

class SendOTP extends SignupEvent {
  final String mobileNumber;
  SendOTP(this.mobileNumber);
}

class UpdateOTP extends SignupEvent {
  final List<String> otpDigits;
  UpdateOTP(this.otpDigits);
}

class VerifyOTP extends SignupEvent {
  final List<String> otpDigits;
  VerifyOTP(this.otpDigits);
}

class ResendOTP extends SignupEvent {}

class StartOTPTimer extends SignupEvent {}

class SignupSubmitted extends SignupEvent {}

// Signup BLoC States
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupOTPField extends SignupState {
  final String mobileNumber;
  final int otpResendTimer;
  
  SignupOTPField({
    required this.mobileNumber,
    required this.otpResendTimer,
  });
}

class SignupMobileVerified extends SignupState {
  final String mobileNumber;
  final List<String> otpDigits;
  
  SignupMobileVerified({
    required this.mobileNumber,
    required this.otpDigits,
  });
}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}

// Signup Data Model
class SignupData {
  final String fullName;
  final String standard;
  final String course;
  final String gender;
  final String mobileNumber;
  final List<String> otpDigits;
  final int otpResendTimer;
  final bool isOTPSent;
  final bool isMobileVerified;

  const SignupData({
    this.fullName = '',
    this.standard = '',
    this.course = 'NEET',
    this.gender = 'Male',
    this.mobileNumber = '',
    this.otpDigits = const ['', '', '', ''],
    this.otpResendTimer = 0,
    this.isOTPSent = false,
    this.isMobileVerified = false,
  });

  SignupData copyWith({
    String? fullName,
    String? standard,
    String? course,
    String? gender,
    String? mobileNumber,
    List<String>? otpDigits,
    int? otpResendTimer,
    bool? isOTPSent,
    bool? isMobileVerified,
  }) {
    return SignupData(
      fullName: fullName ?? this.fullName,
      standard: standard ?? this.standard,
      course: course ?? this.course,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      otpDigits: otpDigits ?? this.otpDigits,
      otpResendTimer: otpResendTimer ?? this.otpResendTimer,
      isOTPSent: isOTPSent ?? this.isOTPSent,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
    );
  }
}

class SignupLoaded extends SignupState {
  final SignupData data;
  
  SignupLoaded({required this.data});
}

// Signup BLoC
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupInitialized>(_onSignupInitialized);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateStandard>(_onUpdateStandard);
    on<UpdateCourse>(_onUpdateCourse);
    on<UpdateGender>(_onUpdateGender);
    on<UpdateMobileNumber>(_onUpdateMobileNumber);
    on<SendOTP>(_onSendOTP);
    on<UpdateOTP>(_onUpdateOTP);
    on<VerifyOTP>(_onVerifyOTP);
    on<ResendOTP>(_onResendOTP);
    on<StartOTPTimer>(_onStartOTPTimer);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  void _onSignupInitialized(SignupInitialized event, Emitter<SignupState> emit) {
    emit(SignupLoaded(data: const SignupData()));
  }

  void _onUpdateFullName(UpdateFullName event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(fullName: event.fullName),
      ));
    }
  }

  void _onUpdateStandard(UpdateStandard event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(standard: event.standard),
      ));
    }
  }

  void _onUpdateCourse(UpdateCourse event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(course: event.course),
      ));
    }
  }

  void _onUpdateGender(UpdateGender event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(gender: event.gender),
      ));
    }
  }

  void _onUpdateMobileNumber(UpdateMobileNumber event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(mobileNumber: event.mobileNumber),
      ));
    }
  }

  void _onSendOTP(SendOTP event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      
      // Validate mobile number

      print('Mobile Number ${event.mobileNumber}');
      if (event.mobileNumber.isEmpty || event.mobileNumber.length != 10) {
        emit(SignupError('Please enter a valid mobile number'));
        return;
      }

      emit(SignupOTPField(
        mobileNumber: event.mobileNumber,
        otpResendTimer: 20,
      ));

      // Start OTP timer
      add(StartOTPTimer());
    }
  }

  void _onUpdateOTP(UpdateOTP event, Emitter<SignupState> emit) {
    if (state is SignupOTPField) {
      final currentState = state as SignupOTPField;
      
      // Check if all OTP digits are filled
      if (event.otpDigits.every((digit) => digit.isNotEmpty)) {
        add(VerifyOTP(event.otpDigits));
      } else {
        emit(SignupOTPField(
          mobileNumber: currentState.mobileNumber,
          otpResendTimer: currentState.otpResendTimer,
        ));
      }
    }
  }

  void _onVerifyOTP(VerifyOTP event, Emitter<SignupState> emit) {
    if (state is SignupOTPField) {
      final currentState = state as SignupOTPField;
      
      // Simulate OTP verification (replace with actual API call)
      // For demo purposes, accept any 4-digit OTP
      if (event.otpDigits.every((digit) => digit.isNotEmpty && digit.length == 1)) {
        emit(SignupMobileVerified(
          mobileNumber: currentState.mobileNumber,
          otpDigits: event.otpDigits,
        ));
      } else {
        emit(SignupError('Invalid OTP. Please try again.'));
      }
    }
  }

  void _onResendOTP(ResendOTP event, Emitter<SignupState> emit) {
    if (state is SignupOTPField) {
      final currentState = state as SignupOTPField;
      
      emit(SignupOTPField(
        mobileNumber: currentState.mobileNumber,
        otpResendTimer: 20,
      ));

      // Start OTP timer
      add(StartOTPTimer());
    }
  }

  void _onStartOTPTimer(StartOTPTimer event, Emitter<SignupState> emit) {
    if (state is SignupOTPField) {
      final currentState = state as SignupOTPField;
      
      // Start countdown timer
      _startCountdown(currentState, emit);
    }
  }

  void _startCountdown(SignupOTPField currentState, Emitter<SignupState> emit) {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      
      if (state is SignupOTPField) {
        final state = this.state as SignupOTPField;
        if (state.otpResendTimer > 0) {
          emit(SignupOTPField(
            mobileNumber: state.mobileNumber,
            otpResendTimer: state.otpResendTimer - 1,
          ));
          return true;
        }
      }
      return false;
    });
  }

  void _onSignupSubmitted(SignupSubmitted event, Emitter<SignupState> emit) {
    emit(SignupLoading());
    
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      if (!isClosed) {
        emit(SignupSuccess());
      }
    });
  }
}
