import 'package:dio/dio.dart';
import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_models/forgot_password_verification_model.dart';
import '../../../core/api_models/forgot_password_model.dart';
import '../../../core/api_models/reset_password_model.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';

class ForgotPasswordVerificationRepository {
  final DioClient _dioClient = DioClient();

  /// Verify OTP for forgot password
  Future<ApiResponse<ForgotPasswordVerificationResponse>> verifyForgotPasswordOTP({
    required String mobile,
    required String otp,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.forgotPasswordVerification,
        queryParameters: {
          'stu_mobile': mobile,
          'stu_forverf': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          try {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic>
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            final verificationResponse = ForgotPasswordVerificationResponse.fromJson(responseData);
            return ApiResponse.success(data: verificationResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to verify OTP') : 'Failed to verify OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to verify OTP',
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

  /// Resend OTP for forgot password
  Future<ApiResponse<ForgotPasswordResponse>> resendForgotPasswordOTP({
    required String mobile,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.forgotPasswordReSendOTP,
        queryParameters: {
          'stu_mobile': mobile,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          try {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic>
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            final forgotPasswordResponse = ForgotPasswordResponse.fromJson(responseData);
            return ApiResponse.success(data: forgotPasswordResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to resend OTP') : 'Failed to resend OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to resend OTP',
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

  /// Reset password for forgot password flow
  Future<ApiResponse<ResetPasswordResponse>> resetPassword({
    required String mobile,
    required String otp,
    required String password,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.resetPassword,
        queryParameters: {
          'stu_mobile': mobile,
          'stu_forverf': otp,
          'stu_password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          try {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic>
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            final resetPasswordResponse = ResetPasswordResponse.fromJson(responseData);
            return ApiResponse.success(data: resetPasswordResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to reset password') : 'Failed to reset password',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to reset password',
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

