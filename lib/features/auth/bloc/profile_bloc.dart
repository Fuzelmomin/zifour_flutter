import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/profile_repository.dart';
import '../../../core/api_models/profile_model.dart';
import '../../../core/api_models/standard_model.dart';
import '../../../core/api_models/exam_model.dart';
import '../../../core/api_models/medium_model.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/user_preference.dart';
import '../../../core/utils/connectivity_helper.dart';

// Profile BLoC Events
abstract class ProfileEvent {}

class ProfileInitialized extends ProfileEvent {}

class FetchProfile extends ProfileEvent {
  final String stuId;
  FetchProfile({required this.stuId});
}

class UpdateProfileName extends ProfileEvent {
  final String name;
  UpdateProfileName(this.name);
}

class UpdateProfileEmail extends ProfileEvent {
  final String email;
  UpdateProfileEmail(this.email);
}

class UpdateProfileCity extends ProfileEvent {
  final String city;
  UpdateProfileCity(this.city);
}

class UpdateProfilePincode extends ProfileEvent {
  final String pincode;
  UpdateProfilePincode(this.pincode);
}

class UpdateProfileAddress extends ProfileEvent {
  final String address;
  UpdateProfileAddress(this.address);
}

class UpdateProfileStandard extends ProfileEvent {
  final String stdId;
  final String stdName;
  UpdateProfileStandard({required this.stdId, required this.stdName});
}

class UpdateProfileExam extends ProfileEvent {
  final String exmId;
  final String exmName;
  UpdateProfileExam({required this.exmId, required this.exmName});
}

class UpdateProfileMedium extends ProfileEvent {
  final String medId;
  final String medName;
  UpdateProfileMedium({required this.medId, required this.medName});
}

class UpdateProfileGender extends ProfileEvent {
  final int gender;
  UpdateProfileGender(this.gender);
}

class ProfileUpdateSubmitted extends ProfileEvent {}

// Profile BLoC States
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileData profileData;
  final List<NewStandardModel> standardList;
  final List<NewExamModel> examList;
  final List<NewMediumModel> mediumList;
  final String selectedStdId;
  final String selectedExmId;
  final String selectedMedId;
  final int selectedGender;

  ProfileLoaded({
    required this.profileData,
    required this.standardList,
    required this.examList,
    required this.mediumList,
    required this.selectedStdId,
    required this.selectedExmId,
    required this.selectedMedId,
    required this.selectedGender,
  });

  ProfileLoaded copyWith({
    ProfileData? profileData,
    List<NewStandardModel>? standardList,
    List<NewExamModel>? examList,
    List<NewMediumModel>? mediumList,
    String? selectedStdId,
    String? selectedExmId,
    String? selectedMedId,
    int? selectedGender,
  }) {
    return ProfileLoaded(
      profileData: profileData ?? this.profileData,
      standardList: standardList ?? this.standardList,
      examList: examList ?? this.examList,
      mediumList: mediumList ?? this.mediumList,
      selectedStdId: selectedStdId ?? this.selectedStdId,
      selectedExmId: selectedExmId ?? this.selectedExmId,
      selectedMedId: selectedMedId ?? this.selectedMedId,
      selectedGender: selectedGender ?? this.selectedGender,
    );
  }
}

class ProfileUpdating extends ProfileState {
  final ProfileLoaded previousState;
  ProfileUpdating(this.previousState);
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// Profile BLoC
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository = ProfileRepository();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileInitialized>(_onProfileInitialized);
    on<FetchProfile>(_onFetchProfile);
    on<UpdateProfileName>(_onUpdateProfileName);
    on<UpdateProfileEmail>(_onUpdateProfileEmail);
    on<UpdateProfileCity>(_onUpdateProfileCity);
    on<UpdateProfilePincode>(_onUpdateProfilePincode);
    on<UpdateProfileAddress>(_onUpdateProfileAddress);
    on<UpdateProfileStandard>(_onUpdateProfileStandard);
    on<UpdateProfileExam>(_onUpdateProfileExam);
    on<UpdateProfileMedium>(_onUpdateProfileMedium);
    on<UpdateProfileGender>(_onUpdateProfileGender);
    on<ProfileUpdateSubmitted>(_onProfileUpdateSubmitted);
  }

  Future<void> _onProfileInitialized(
    ProfileInitialized event,
    Emitter<ProfileState> emit,
  ) async {
    final userData = await UserPreference.getUserData();
    if (userData != null) {
      add(FetchProfile(stuId: userData.stuId));
    } else {
      emit(ProfileError('User data not found'));
    }
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // Check internet connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      emit(ProfileError('No internet connection. Please check your network and try again.'));
      return;
    }

    try {
      final response = await _repository.getProfile(stuId: event.stuId);

      if (response.status == ApiStatus.success && response.data != null) {
        final profileResponse = response.data!;
        final profileData = profileResponse.data;

        if (profileData != null) {
          emit(ProfileLoaded(
            profileData: profileData,
            standardList: profileResponse.standardList ?? [],
            examList: profileResponse.examList ?? [],
            mediumList: profileResponse.mediumList ?? [],
            selectedStdId: profileData.stuStdId,
            selectedExmId: profileData.stuExmId,
            selectedMedId: profileData.stuMedId,
            selectedGender: profileData.stuGender,
          ));
        } else {
          emit(ProfileError('Profile data not found'));
        }
      } else {
        emit(ProfileError(response.errorMsg ?? 'Failed to fetch profile'));
      }
    } catch (e, stack) {
      print(stack);
      emit(ProfileError('Error: ${e.toString()}'));

    }
  }

  void _onUpdateProfileName(
    UpdateProfileName event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage ?? '',
        stuSince: currentState.profileData.stuSince ?? '',
        stuName: event.name,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail ?? '',
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument ?? '',
        stuCity: currentState.profileData.stuCity ?? '',
        stuPincode: currentState.profileData.stuPincode ?? '',
        stuAddress: currentState.profileData.stuAddress ?? '',
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(profileData: updatedData));
    }
  }

  void _onUpdateProfileEmail(
    UpdateProfileEmail event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: event.email,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(profileData: updatedData));
    }
  }

  void _onUpdateProfileCity(
    UpdateProfileCity event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: event.city,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(profileData: updatedData));
    }
  }

  void _onUpdateProfilePincode(
    UpdateProfilePincode event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: event.pincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(profileData: updatedData));
    }
  }

  void _onUpdateProfileAddress(
    UpdateProfileAddress event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: event.address,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(profileData: updatedData));
    }
  }

  void _onUpdateProfileStandard(
    UpdateProfileStandard event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: event.stdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(
        profileData: updatedData,
        selectedStdId: event.stdId,
      ));
    }
  }

  void _onUpdateProfileExam(
    UpdateProfileExam event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: event.exmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(
        profileData: updatedData,
        selectedExmId: event.exmId,
      ));
    }
  }

  void _onUpdateProfileMedium(
    UpdateProfileMedium event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: currentState.profileData.stuGender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: event.medId,
      );
      emit(currentState.copyWith(
        profileData: updatedData,
        selectedMedId: event.medId,
      ));
    }
  }

  void _onUpdateProfileGender(
    UpdateProfileGender event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedData = ProfileData(
        stuId: currentState.profileData.stuId,
        stuImage: currentState.profileData.stuImage,
        stuSince: currentState.profileData.stuSince,
        stuName: currentState.profileData.stuName,
        stuMobile: currentState.profileData.stuMobile,
        stuEmail: currentState.profileData.stuEmail,
        stuGender: event.gender,
        stuDocument: currentState.profileData.stuDocument,
        stuCity: currentState.profileData.stuCity,
        stuPincode: currentState.profileData.stuPincode,
        stuAddress: currentState.profileData.stuAddress,
        stuStdId: currentState.profileData.stuStdId,
        stuExmId: currentState.profileData.stuExmId,
        stuMedId: currentState.profileData.stuMedId,
      );
      emit(currentState.copyWith(selectedGender: event.gender, profileData: updatedData));
    }
  }

  Future<void> _onProfileUpdateSubmitted(
    ProfileUpdateSubmitted event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(ProfileUpdating(currentState));

      // Check internet connectivity
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        emit(ProfileError('No internet connection. Please check your network and try again.'));
        emit(currentState);
        return;
      }

      try {
        final response = await _repository.updateProfile(
          stuId: currentState.profileData.stuId,
          stuName: currentState.profileData.stuName,
          stuEmail: currentState.profileData.stuEmail ?? '',
          stuCity: currentState.profileData.stuCity ?? '',
          stuPincode: currentState.profileData.stuPincode ?? '',
          stuAddress: currentState.profileData.stuAddress ?? '',
          stuStdId: currentState.selectedStdId,
          stuExmId: currentState.selectedExmId,
          stuMedId: currentState.selectedMedId,
        );

        if (response.status == ApiStatus.success && response.data != null) {
          // Save updated user data to SharedPreferences
          if (response.data!.data != null) {
            await UserPreference.saveUserData(response.data!.data!);
          }
          
          emit(ProfileUpdateSuccess(response.data!.message));
        } else {
          emit(ProfileError(response.errorMsg ?? 'Failed to update profile'));
          emit(currentState);
        }
      } catch (e) {
        emit(ProfileError('Error: ${e.toString()}'));
        emit(currentState);
      }
    }
  }
}

