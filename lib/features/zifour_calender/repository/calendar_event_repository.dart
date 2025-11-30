import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../model/calendar_event_model.dart';

class CalendarEventRepository {
  CalendarEventRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<CalendarEventResponse>> createEvent({
    required String studentId,
    required String date,
    required String time,
    required String title,
    required String description,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().post(
        APIConstants.createCalenderEvent,
        queryParameters: {
          'stu_id': studentId,
          'calevt_date': date,
          'calevt_time': time,
          'calevt_title': title,
          'calevt_description': description,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final eventResponse = CalendarEventResponse.fromJson(data);
          return ApiResponse.success(data: eventResponse);
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message']?.toString() ?? 'Unable to create event')
              : 'Unable to create event',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to create event',
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

