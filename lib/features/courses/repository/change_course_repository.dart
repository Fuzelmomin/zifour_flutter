import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/change_course_model.dart';

class ChangeCourseRepository {
  ChangeCourseRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<ChangeCourseResponse>> changeCourse({
    required String stuId,
    required String stuStdId,
    required String stuExmId,
    required String stuMedId,
    required String stuSubId,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final user = await UserPreference.getUserData();
      if (user == null) {
        return ApiResponse.error(
          errorMsg: 'Please login again to continue.',
        );
      }

      final finalStuId = stuId.isNotEmpty ? stuId : user.stuId;

      final response = await _dioClient.getDio().post(
        APIConstants.changeCourse,
        queryParameters: {
          'stu_id': finalStuId,
          'stu_std_id': stuStdId,
          'stu_exm_id': stuExmId,
          'stu_med_id': stuMedId,
          //'stu_sub_id': stuSubId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final changeCourseResponse = ChangeCourseResponse.fromJson(data);
          return ApiResponse.success(data: changeCourseResponse);
        }

        return ApiResponse.error(
          errorMsg: 'Invalid response format',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to change course',
      );
    } on DioException catch (error) {
      final apiError = ApiUtils.getApiError(error);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (error) {
      return ApiResponse.error(
        status: ApiStatus.error,
        errorMsg: 'Unexpected error: ${error.toString()}',
      );
    }
  }
}

