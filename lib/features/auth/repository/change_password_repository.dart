import 'package:dio/dio.dart';
import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_models/change_password_model.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';

class ChangePasswordRepository {
  final DioClient _dioClient = DioClient();

  /// Change password
  Future<ApiResponse<ChangePasswordResponse>> changePassword({
    required String stuId,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.changePassword,
        queryParameters: {
          'stu_id': stuId,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final changePasswordResponse = ChangePasswordResponse.fromJson(data);
          return ApiResponse.success(data: changePasswordResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to change password',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to change password',
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

