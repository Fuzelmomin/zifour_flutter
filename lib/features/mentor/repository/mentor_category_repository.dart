import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/mentor_category_model.dart';
import '../../../core/utils/connectivity_helper.dart';

class MentorCategoryRepository {
  MentorCategoryRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<MentorCategoryResponse>> fetchMentorCategories() async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().get(
        APIConstants.mentorCategory,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = MentorCategoryResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load mentor categories.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load mentor categories.',
      );
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred.',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}
