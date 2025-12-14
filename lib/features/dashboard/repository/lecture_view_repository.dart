import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/lecture_view_model.dart';

class LectureViewRepository {
  LectureViewRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<LectureViewResponse>> markLectureAsViewed({
    required String lecId,
    String? stuId,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        // Silent failure - don't show error for connectivity issues
        return ApiResponse.error(
          errorMsg: 'No internet connection.',
        );
      }

      final user = await UserPreference.getUserData();
      if (user == null) {
        // Silent failure - don't show error if user not logged in
        return ApiResponse.error(
          errorMsg: 'User not logged in.',
        );
      }

      final finalStuId = stuId ?? user.stuId;

      final response = await _dioClient.getDio().post(
        APIConstants.lectureView,
        queryParameters: {
          'stu_id': finalStuId,
          'lec_id': lecId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final viewResponse = LectureViewResponse.fromJson(data);
          return ApiResponse.success(data: viewResponse);
        }

        return ApiResponse.error(
          errorMsg: 'Invalid response format',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to mark lecture as viewed',
      );
    } on DioException catch (error) {
      // Silent failure - don't show error for network issues
      final apiError = ApiUtils.getApiError(error);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (error) {
      // Silent failure
      return ApiResponse.error(
        status: ApiStatus.error,
        errorMsg: 'Unexpected error: ${error.toString()}',
      );
    }
  }
}

