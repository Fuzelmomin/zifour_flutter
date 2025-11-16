import 'package:dio/dio.dart';
import '../api_client/api_constans.dart';
import '../api_client/dio_client.dart';
import '../api_client/api_utils.dart';
import '../api_models/medium_model.dart';
import '../api_models/api_response.dart';
import '../api_models/api_status.dart';

class MediumRepository {
  final DioClient _dioClient = DioClient();

  Future<ApiResponse<MediumResponse>> getMediumLanguages() async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.mediumLanguage,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final mediumResponse = MediumResponse.fromJson(data);
          return ApiResponse.success(data: mediumResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to fetch languages',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to fetch languages',
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

