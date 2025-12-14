import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/lecture_reminder_model.dart';

class LectureReminderRepository {
  LectureReminderRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<LectureReminderResponse>> addLectureReminder({
    required String lecId,
    required String reminderDate,
    String? stuId,
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

      final finalStuId = stuId ?? user.stuId;

      final response = await _dioClient.getDio().post(
        APIConstants.addLectureReminder,
        queryParameters: {
          'stu_id': finalStuId,
          'lec_id': lecId,
          'reminder_date': reminderDate,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final reminderResponse = LectureReminderResponse.fromJson(data);
          return ApiResponse.success(data: reminderResponse);
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message']?.toString() ?? 'Unable to add reminder')
              : 'Unable to add reminder',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to add reminder',
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

