import 'package:dio/dio.dart';
import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_models/forgot_password_model.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';

class ForgotPasswordRepository {
  final DioClient _dioClient = DioClient();

  /// Send OTP for forgot password
  Future<ApiResponse<ForgotPasswordResponse>> sendForgotPasswordOTP({
    required String mobile,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.forgotPasswordSendOTP,
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
            errorMsg: data is Map ? (data['message'] ?? 'Failed to send OTP') : 'Failed to send OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to send OTP',
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

