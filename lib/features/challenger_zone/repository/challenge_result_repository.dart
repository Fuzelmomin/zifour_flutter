import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/challenge_result_model.dart';

class ChallengeResultRepository {
  ChallengeResultRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<ChallengeResultResponse>> getChallengeResult({
    required String crtChlId,
    required String apiType,
    required String? pkId,
    required String? paperId,
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

      var response;

      // 1, 4 = TestSeries, 2, 3 = Challenge
      if(apiType == "1" || apiType == "4"){
        response = await _dioClient.getDio().post(
          APIConstants.testSeriesResult,
          queryParameters: {
            'stu_id': user.stuId,
            'pk_id': pkId,
            'g_pa_id': paperId,
          },
        );
      }else {
        response = await _dioClient.getDio().post(
          APIConstants.createChallengeResult,
          queryParameters: {
            'stu_id': user.stuId,
            'crt_chl_id': crtChlId,
          },
        );
      }

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model =
              ChallengeResultResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg:
              data['message']?.toString() ?? 'Unable to fetch challenge result.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to fetch challenge result.',
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
