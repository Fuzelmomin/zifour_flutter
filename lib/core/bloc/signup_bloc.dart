import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api_models/standard_model.dart';
import '../api_models/exam_model.dart';
import '../api_models/api_status.dart';
import '../repositories/signup_repository.dart';
import '../utils/language_preference.dart';

// Signup BLoC Events
abstract class SignupEvent {}

class SignupInitialized extends SignupEvent {}

class FetchStandards extends SignupEvent {}

class FetchExams extends SignupEvent {}

class UpdateFullName extends SignupEvent {
  final String fullName;
  UpdateFullName(this.fullName);
}

class UpdateStandard extends SignupEvent {
  final String standard;
  final String? stdId; // Store std_id from API
  UpdateStandard(this.standard, {this.stdId});
}

class UpdateCourse extends SignupEvent {
  final String course;
  final String? exmId; // Store exm_id from API
  UpdateCourse(this.course, {this.exmId});
}

class UpdateImage extends SignupEvent {
  final File? imageFile;
  UpdateImage(this.imageFile);
}

class UpdatePassword extends SignupEvent {
  final String password;
  UpdatePassword(this.password);
}

class UpdateConfirmPassword extends SignupEvent {
  final String confirmPassword;
  UpdateConfirmPassword(this.confirmPassword);
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

class UpdateOTPTimer extends SignupEvent {}

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
  // Store standards and exams to preserve selections in UI
  final List<StandardModel>? standards;
  final List<ExamModel>? exams;
  final File? imageFile; // Store image file to preserve selection
  final String? stdId;
  final String? exmId;
  
  SignupMobileVerified({
    required this.mobileNumber,
    required this.otpDigits,
    this.standards,
    this.exams,
    this.imageFile,
    this.stdId,
    this.exmId,
  });
}

class SignupSuccess extends SignupState {}

class SignupError extends SignupState {
  final String message;
  SignupError(this.message);
}

class StandardsLoaded extends SignupState {
  final List<StandardModel> standards;
  StandardsLoaded(this.standards);
}

class ExamsLoaded extends SignupState {
  final List<ExamModel> exams;
  ExamsLoaded(this.exams);
}

class ImageUploading extends SignupState {
  final SignupData data;
  final List<StandardModel>? standards;
  final List<ExamModel>? exams;
  
  ImageUploading({
    required this.data,
    this.standards,
    this.exams,
  });
}

class ImageUploaded extends SignupState {
  final String imageUrl;
  ImageUploaded(this.imageUrl);
}

class OtpSending extends SignupState {
  final SignupData data;
  final List<StandardModel>? standards;
  final List<ExamModel>? exams;
  
  OtpSending({
    required this.data,
    this.standards,
    this.exams,
  });
}

class OtpSent extends SignupState {
  final String mobileNumber;
  final String stuVerification;
  final int otpResendTimer;
  // Store signup data for resend OTP
  final String name;
  final String stdId;
  final String exmId;
  final String password;
  final String imageUrl;
  final String? gender;
  // Store standards and exams to preserve selections in UI
  final List<StandardModel>? standards;
  final List<ExamModel>? exams;
  final File? imageFile; // Store image file to preserve selection
  
  OtpSent({
    required this.mobileNumber,
    required this.stuVerification,
    required this.otpResendTimer,
    required this.name,
    required this.stdId,
    required this.exmId,
    required this.password,
    required this.imageUrl,
    this.gender,
    this.standards,
    this.exams,
    this.imageFile,
  });
}

class OtpVerifying extends SignupState {}

// Signup Data Model
class SignupData {
  final String fullName;
  final String standard;
  final String? stdId; // Store std_id from API
  final String course;
  final String? exmId; // Store exm_id from API
  final String gender;
  final String mobileNumber;
  final String password;
  final String confirmPassword;
  final File? imageFile;
  final String? imageUrl;
    final List<String> otpDigits;
    final int otpResendTimer;
    final bool isOTPSent;
    final bool isMobileVerified;
    final String? stuVerification; // Store from SendOTP response

  const SignupData({
    this.fullName = '',
    this.standard = '',
    this.stdId,
    this.course = 'NEET',
    this.exmId,
    this.gender = 'Male',
    this.mobileNumber = '',
    this.password = '',
    this.confirmPassword = '',
    this.imageFile,
    this.imageUrl,
    this.otpDigits = const ['', '', '', '', '', ''],
    this.otpResendTimer = 0,
    this.isOTPSent = false,
    this.isMobileVerified = false,
    this.stuVerification,
  });

  SignupData copyWith({
    String? fullName,
    String? standard,
    String? stdId,
    String? course,
    String? exmId,
    String? gender,
    String? mobileNumber,
    String? password,
    String? confirmPassword,
    File? imageFile,
    String? imageUrl,
    List<String>? otpDigits,
    int? otpResendTimer,
    bool? isOTPSent,
    bool? isMobileVerified,
    String? stuVerification,
  }) {
    return SignupData(
      fullName: fullName ?? this.fullName,
      standard: standard ?? this.standard,
      stdId: stdId ?? this.stdId,
      course: course ?? this.course,
      exmId: exmId ?? this.exmId,
      gender: gender ?? this.gender,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      imageFile: imageFile ?? this.imageFile,
      imageUrl: imageUrl ?? this.imageUrl,
      otpDigits: otpDigits ?? this.otpDigits,
      otpResendTimer: otpResendTimer ?? this.otpResendTimer,
      isOTPSent: isOTPSent ?? this.isOTPSent,
      isMobileVerified: isMobileVerified ?? this.isMobileVerified,
      stuVerification: stuVerification ?? this.stuVerification,
    );
  }
}

class SignupLoaded extends SignupState {
  final SignupData data;
  final List<StandardModel>? standards;
  final List<ExamModel>? exams;
  
  SignupLoaded({
    required this.data,
    this.standards,
    this.exams,
  });
}

// Signup BLoC
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupRepository _signupRepository = SignupRepository();
  List<StandardModel>? _standards;
  List<ExamModel>? _exams;
  
  SignupBloc() : super(SignupInitial()) {
    on<SignupInitialized>(_onSignupInitialized);
    on<FetchStandards>(_onFetchStandards);
    on<FetchExams>(_onFetchExams);
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateStandard>(_onUpdateStandard);
    on<UpdateCourse>(_onUpdateCourse);
    on<UpdateGender>(_onUpdateGender);
    on<UpdateMobileNumber>(_onUpdateMobileNumber);
    on<UpdateImage>(_onUpdateImage);
    on<UpdatePassword>(_onUpdatePassword);
    on<UpdateConfirmPassword>(_onUpdateConfirmPassword);
    on<SendOTP>(_onSendOTP);
    on<UpdateOTP>(_onUpdateOTP);
    on<VerifyOTP>(_onVerifyOTP);
    on<ResendOTP>(_onResendOTP);
    on<UpdateOTPTimer>(_onUpdateOTPTimer);
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }

  void _onSignupInitialized(SignupInitialized event, Emitter<SignupState> emit) {
    emit(SignupLoaded(data: const SignupData()));
    // Fetch standards and exams on initialization
    add(FetchStandards());
    add(FetchExams());
  }

  Future<void> _onFetchStandards(FetchStandards event, Emitter<SignupState> emit) async {
    try {
      final response = await _signupRepository.fetchStandards();
      
      if (response.status == ApiStatus.success && response.data != null) {
        _standards = response.data!.standardList;
        
        if (state is SignupLoaded) {
          final currentState = state as SignupLoaded;
          emit(SignupLoaded(
            data: currentState.data,
            standards: _standards,
            exams: currentState.exams,
          ));
        } else {
          emit(StandardsLoaded(_standards!));
        }
      } else {
        emit(SignupError(response.errorMsg ?? 'Failed to fetch standards'));
      }
    } catch (e, stack) {
      print(stack);
      emit(SignupError('Error fetching standards: ${e.toString()}'));
    }
  }

  Future<void> _onFetchExams(FetchExams event, Emitter<SignupState> emit) async {
    try {
      final response = await _signupRepository.fetchExams();
      
      if (response.status == ApiStatus.success && response.data != null) {
        _exams = response.data!.examList;
        
        if (state is SignupLoaded) {
          final currentState = state as SignupLoaded;
          emit(SignupLoaded(
            data: currentState.data,
            standards: currentState.standards,
            exams: _exams,
          ));
        } else {
          emit(ExamsLoaded(_exams!));
        }
      } else {
        emit(SignupError(response.errorMsg ?? 'Failed to fetch exams'));
      }
    } catch (e, stack) {
      print(stack);
      emit(SignupError('Error fetching exams: ${e.toString()}'));
    }
  }

  void _onUpdateFullName(UpdateFullName event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(fullName: event.fullName),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateStandard(UpdateStandard event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(
          standard: event.standard,
          stdId: event.stdId,
        ),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateCourse(UpdateCourse event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(
          course: event.course,
          exmId: event.exmId,
        ),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateImage(UpdateImage event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(imageFile: event.imageFile),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdatePassword(UpdatePassword event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(password: event.password),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateConfirmPassword(UpdateConfirmPassword event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(confirmPassword: event.confirmPassword),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateGender(UpdateGender event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(gender: event.gender),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  void _onUpdateMobileNumber(UpdateMobileNumber event, Emitter<SignupState> emit) {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      emit(SignupLoaded(
        data: currentState.data.copyWith(mobileNumber: event.mobileNumber),
        standards: currentState.standards,
        exams: currentState.exams,
      ));
    }
  }

  Future<void> _onSendOTP(SendOTP event, Emitter<SignupState> emit) async {
    if (state is SignupLoaded) {
      final currentState = state as SignupLoaded;
      final data = currentState.data;
      
      // Validate all required fields
      if (data.fullName.isEmpty) {
        emit(SignupError('Please enter your full name'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.gender.isEmpty) {
        emit(SignupError('Please select gender'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.stdId == null || data.stdId!.isEmpty) {
        emit(SignupError('Please select standard'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.exmId == null || data.exmId!.isEmpty) {
        emit(SignupError('Please select course'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.password.isEmpty) {
        emit(SignupError('Please enter password'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.confirmPassword.isEmpty) {
        emit(SignupError('Please confirm password'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.password != data.confirmPassword) {
        emit(SignupError('Passwords do not match'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (event.mobileNumber.isEmpty || event.mobileNumber.length != 10) {
        emit(SignupError('Please enter a valid mobile number'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }
      if (data.imageFile == null) {
        emit(SignupError('Please upload marksheet image'));
        // Restore SignupLoaded state to preserve selections
        emit(SignupLoaded(
          data: data,
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        return;
      }

      // Step 1: Upload Image
      emit(ImageUploading(
        data: data,
        standards: currentState.standards,
        exams: currentState.exams,
      ));
      
      try {

        final medId = await LanguagePreference.getSelectedMediumId();

        final imageResponse = await _signupRepository.uploadImage(
          imageFile: data.imageFile!,
        );

        if (imageResponse.status != ApiStatus.success || 
            imageResponse.data == null || 
            imageResponse.data!.imageurl == null) {
          emit(SignupError(imageResponse.errorMsg ?? 'Failed to upload image'));
          // Restore SignupLoaded state with standards/exams preserved
          emit(SignupLoaded(
            data: data,
            standards: currentState.standards,
            exams: currentState.exams,
          ));
          return;
        }

        final imageUrl = imageResponse.data!.imageurl!;
        
        // Update state with imageUrl
        emit(SignupLoaded(
          data: data.copyWith(imageUrl: imageUrl),
          standards: currentState.standards,
          exams: currentState.exams,
        ));

        // Step 2: Send OTP
        emit(OtpSending(
          data: data.copyWith(imageUrl: imageUrl),
          standards: currentState.standards,
          exams: currentState.exams,
        ));
        
        final otpResponse = await _signupRepository.sendOTP(
          name: data.fullName,
          stdId: data.stdId!,
          exmId: data.exmId!,
          password: data.password,
          mobile: event.mobileNumber,
          imageUrl: imageUrl,
          stuMedId: medId ?? '2',
          gender: data.gender,
        );

        if (otpResponse.status == ApiStatus.success && 
            otpResponse.data != null) {
          
          // OTP sent successfully - show OTP field
          // Note: stuVerification is the OTP code that user will enter, not returned from API
          // We'll use an empty string or generate a placeholder - the actual OTP is sent to user's mobile
          emit(OtpSent(
            mobileNumber: event.mobileNumber,
            stuVerification: '', // OTP will be entered by user, not from API response
            otpResendTimer: 20,
            name: data.fullName,
            stdId: data.stdId!,
            exmId: data.exmId!,
            password: data.password,
            imageUrl: imageUrl,
            gender: data.gender,
            standards: currentState.standards, // Preserve standards for UI
            exams: currentState.exams, // Preserve exams for UI
            imageFile: data.imageFile, // Preserve image file for UI
          ));

        } else {
          emit(SignupError(otpResponse.errorMsg ?? 'Failed to send OTP'));
          // Restore SignupLoaded state with standards/exams preserved
          emit(SignupLoaded(
            data: data.copyWith(imageUrl: imageUrl),
            standards: currentState.standards,
            exams: currentState.exams,
          ));
        }
      } catch (e) {
        emit(SignupError('Error: ${e.toString()}'));
        // Restore SignupLoaded state with standards/exams preserved
        // Check if we have the data from the current state
        if (state is OtpSending) {
          final otpState = state as OtpSending;
          emit(SignupLoaded(
            data: otpState.data,
            standards: otpState.standards,
            exams: otpState.exams,
          ));
        } else if (state is ImageUploading) {
          final imgState = state as ImageUploading;
          emit(SignupLoaded(
            data: imgState.data,
            standards: imgState.standards,
            exams: imgState.exams,
          ));
        } else {
          emit(SignupLoaded(
            data: data,
            standards: currentState.standards,
            exams: currentState.exams,
          ));
        }
      }
    }
  }

  void _onUpdateOTP(UpdateOTP event, Emitter<SignupState> emit) {
    if (state is OtpSent) {
      final currentState = state as OtpSent;
      
      // Check if all OTP digits are filled
      if (event.otpDigits.every((digit) => digit.isNotEmpty)) {
        add(VerifyOTP(event.otpDigits));
      } else {
        // Just update OTP digits in state if needed
        // For now, we don't store OTP digits in OtpSent, so we just verify when all filled
      }
    }
  }

  Future<void> _onVerifyOTP(VerifyOTP event, Emitter<SignupState> emit) async {
    if (state is OtpSent) {
      final currentState = state as OtpSent;
      
      // Combine OTP digits
      final otpCode = event.otpDigits.join('');
      
      if (otpCode.length != 6) {
        emit(SignupError('Please enter complete OTP'));
        return;
      }

      emit(OtpVerifying());
      
      try {
        final verifyResponse = await _signupRepository.verifyOTP(
          stuVerification: otpCode,
          stuMobile: currentState.mobileNumber,
        );

        if (verifyResponse.status == ApiStatus.success) {
          emit(SignupMobileVerified(
            mobileNumber: currentState.mobileNumber,
            otpDigits: event.otpDigits,
            standards: currentState.standards,
            exams: currentState.exams,
            imageFile: currentState.imageFile,
            stdId: currentState.stdId,
            exmId: currentState.exmId,
          ));
        } else {
          emit(SignupError(verifyResponse.errorMsg ?? 'Invalid OTP. Please try again.'));
          // Return to OTP field state
          emit(OtpSent(
            mobileNumber: currentState.mobileNumber,
            stuVerification: currentState.stuVerification,
            otpResendTimer: currentState.otpResendTimer,
            name: currentState.name,
            stdId: currentState.stdId,
            exmId: currentState.exmId,
            password: currentState.password,
            imageUrl: currentState.imageUrl,
            gender: currentState.gender,
            standards: currentState.standards,
            exams: currentState.exams,
            imageFile: currentState.imageFile,
          ));
        }
      } catch (e) {
        emit(SignupError('Error verifying OTP: ${e.toString()}'));
        // Return to OTP field state
        emit(OtpSent(
          mobileNumber: currentState.mobileNumber,
          stuVerification: currentState.stuVerification,
          otpResendTimer: currentState.otpResendTimer,
          name: currentState.name,
          stdId: currentState.stdId,
          exmId: currentState.exmId,
          password: currentState.password,
          imageUrl: currentState.imageUrl,
          gender: currentState.gender,
          standards: currentState.standards,
          exams: currentState.exams,
          imageFile: currentState.imageFile,
        ));
      }
    }
  }

  Future<void> _onResendOTP(ResendOTP event, Emitter<SignupState> emit) async {
    if (state is OtpSent) {
      final currentState = state as OtpSent;
      
      // Create temporary SignupData from OtpSent state for loading state
      final tempData = SignupData(
        fullName: currentState.name,
        stdId: currentState.stdId,
        exmId: currentState.exmId,
        password: currentState.password,
        imageUrl: currentState.imageUrl,
        gender: currentState.gender ?? 'Male',
      );
      
      emit(OtpSending(
        data: tempData,
        standards: currentState.standards,
        exams: currentState.exams,
      ));
      
      try {
        // Resend OTP - only need mobile number as per API requirement
        final otpResponse = await _signupRepository.resendOTP(
          mobile: currentState.mobileNumber,
        );

        if (otpResponse.status == ApiStatus.success && 
            otpResponse.data != null) {
          
          // OTP resent successfully
          emit(OtpSent(
            mobileNumber: currentState.mobileNumber,
            stuVerification: '', // OTP will be entered by user, not from API response
            otpResendTimer: 20,
            name: currentState.name,
            stdId: currentState.stdId,
            exmId: currentState.exmId,
            password: currentState.password,
            imageUrl: currentState.imageUrl,
            gender: currentState.gender,
            standards: currentState.standards,
            exams: currentState.exams,
            imageFile: currentState.imageFile,
          ));

        } else {
          emit(SignupError(otpResponse.errorMsg ?? 'Failed to resend OTP'));
          // Return to previous state with preserved data
          emit(currentState);
        }
      } catch (e) {
        emit(SignupError('Error resending OTP: ${e.toString()}'));
        // Return to previous state with preserved data
        emit(currentState);
      }
    }
  }

  void _onUpdateOTPTimer(UpdateOTPTimer event, Emitter<SignupState> emit) {
    if (state is OtpSent) {
      final currentState = state as OtpSent;
      if (currentState.otpResendTimer > 0) {
        emit(OtpSent(
          mobileNumber: currentState.mobileNumber,
          stuVerification: currentState.stuVerification,
          otpResendTimer: currentState.otpResendTimer - 1,
          name: currentState.name,
          stdId: currentState.stdId,
          exmId: currentState.exmId,
          password: currentState.password,
          imageUrl: currentState.imageUrl,
          gender: currentState.gender,
          standards: currentState.standards,
          exams: currentState.exams,
          imageFile: currentState.imageFile,
        ));
      } else {
        _otpTimer?.cancel();
      }
    } else {
      _otpTimer?.cancel();
    }
  }

  Timer? _otpTimer;
  
  void _startCountdown() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      
      // Use add() instead of emit() to avoid emit after handler completion
      add(UpdateOTPTimer());
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
