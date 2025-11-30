import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../model/mentors_list_model.dart';

class GetMentorsRepository {
  GetMentorsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<MentorsListResponse>> getMentors({
    required String subId,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().get(
        APIConstants.getMentors,
        queryParameters: {
          'sub_id': subId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final mentorsResponse = MentorsListResponse.fromJson(data);
          return ApiResponse.success(data: mentorsResponse);
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message']?.toString() ?? 'Unable to load mentors')
              : 'Unable to load mentors',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load mentors',
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

