import 'package:dio/dio.dart';
import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_models/profile_model.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';

class ProfileRepository {
  final DioClient _dioClient = DioClient();

  /// Get profile details
  Future<ApiResponse<ProfileResponse>> getProfile({
    required String stuId,
  }) async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.getProfile,
        queryParameters: {
          'stu_id': stuId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final profileResponse = ProfileResponse.fromJson(data);
          return ApiResponse.success(data: profileResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to fetch profile',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to fetch profile',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e, stack) {
      print(e);
      print(stack);
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Update profile
  Future<ApiResponse<UpdateProfileResponse>> updateProfile({
    required String stuId,
    required String stuName,
    required String stuEmail,
    required String stuCity,
    required String stuPincode,
    required String stuAddress,
    required String stuStdId,
    required String stuExmId,
    required String stuMedId,
  }) async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.updateProfile,
        queryParameters: {
          'stu_id': stuId,
          'stu_name': stuName,
          'stu_email': stuEmail,
          'stu_city': stuCity,
          'stu_pincode': stuPincode,
          'stu_address': stuAddress,
          'stu_std_id': stuStdId,
          'stu_exm_id': stuExmId,
          'stu_med_id': stuMedId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final updateResponse = UpdateProfileResponse.fromJson(data);
          return ApiResponse.success(data: updateResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to update profile',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to update profile',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}

