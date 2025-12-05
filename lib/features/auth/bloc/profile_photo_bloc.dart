import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/profile_repository.dart';
import '../../../core/repositories/signup_repository.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/profile_photo_update_model.dart';
import '../../../core/utils/user_preference.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/api_models/login_model.dart';

// Profile Photo BLoC Events
abstract class ProfilePhotoEvent {}

class UploadAndUpdateProfilePhoto extends ProfilePhotoEvent {
  final File imageFile;
  UploadAndUpdateProfilePhoto(this.imageFile);
}

// Profile Photo BLoC States
abstract class ProfilePhotoState {}

class ProfilePhotoInitial extends ProfilePhotoState {}

class ProfilePhotoUploading extends ProfilePhotoState {}

class ProfilePhotoUpdating extends ProfilePhotoState {}

class ProfilePhotoUpdateSuccess extends ProfilePhotoState {
  final String message;
  ProfilePhotoUpdateSuccess(this.message);
}

class ProfilePhotoError extends ProfilePhotoState {
  final String message;
  ProfilePhotoError(this.message);
}

// Profile Photo BLoC
class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  final ProfileRepository _profileRepository = ProfileRepository();
  final SignupRepository _signupRepository = SignupRepository();

  ProfilePhotoBloc() : super(ProfilePhotoInitial()) {
    on<UploadAndUpdateProfilePhoto>(_onUploadAndUpdateProfilePhoto);
  }

  Future<void> _onUploadAndUpdateProfilePhoto(
    UploadAndUpdateProfilePhoto event,
    Emitter<ProfilePhotoState> emit,
  ) async {
    // Check internet connectivity
    final isConnected = await ConnectivityHelper.checkConnectivity();
    if (!isConnected) {
      emit(ProfilePhotoError('No internet connection. Please check your network and try again.'));
      return;
    }

    try {
      // Get current user data
      final userData = await UserPreference.getUserData();
      if (userData == null) {
        emit(ProfilePhotoError('User data not found'));
        return;
      }

      // Step 1: Upload Image
      emit(ProfilePhotoUploading());

      final imageResponse = await _signupRepository.uploadImage(
        imageFile: event.imageFile,
      );

      if (imageResponse.status != ApiStatus.success ||
          imageResponse.data == null ||
          imageResponse.data!.imageurl == null) {
        emit(ProfilePhotoError(imageResponse.errorMsg ?? 'Failed to upload image'));
        return;
      }

      final imageUrl = imageResponse.data!.imageurl!;

      // Step 2: Update Profile Photo
      emit(ProfilePhotoUpdating());

      final updateResponse = await _profileRepository.updateProfilePhoto(
        stuId: userData.stuId,
        stuImage: imageUrl,
      );

      if (updateResponse.status == ApiStatus.success && updateResponse.data != null) {
        final updatedImageUrl = updateResponse.data!.stuImage;
        
        if (updatedImageUrl != null) {
          // Update user data in SharedPreferences with new image URL
          final updatedUserData = LoginData(
            stuId: userData.stuId,
            stuName: userData.stuName,
            stuImage: updatedImageUrl,
            stuMobile: userData.stuMobile,
            stuEmail: userData.stuEmail,
            stuCity: userData.stuCity,
            stuPincode: userData.stuPincode,
            stuAddress: userData.stuAddress,
            stuStdId: userData.stuStdId,
            stuSubId: userData.stuSubId,
            stuMedId: userData.stuMedId,
            stuExmId: userData.stuExmId,
          );

          // Save updated user data - this will trigger ValueNotifier update
          await UserPreference.saveUserData(updatedUserData);

          emit(ProfilePhotoUpdateSuccess(updateResponse.data!.message));
        } else {
          emit(ProfilePhotoError('Failed to get updated image URL'));
        }
      } else {
        emit(ProfilePhotoError(updateResponse.errorMsg ?? 'Failed to update profile photo'));
      }
    } catch (e) {
      emit(ProfilePhotoError('Error: ${e.toString()}'));
    }
  }
}

