import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/challenge_mcq_list_model.dart';

class ChallengeMcqListRepository {
  ChallengeMcqListRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<ChallengeMcqListResponse>> fetchMcqList({
    required String crtChlId,
    required String apiType,
    String? sampleTest,
    String? topicId,
    String? pkId,
    String? paperId,

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
      if(apiType == "1"){
        response = await _dioClient.getDio().post(
          APIConstants.getPracticeMCQ,
          queryParameters: {
            'sample_test': sampleTest,
            'tpc_id': topicId,
            'stu_id': user.stuId,
          },
        );
      } else if(apiType == "4"){
        response = await _dioClient.getDio().post(
          APIConstants.getPracticeMCQ,
          queryParameters: {
            'sample_test': sampleTest,
            'chp_id': "0",
            'stu_id': user.stuId,
            'g_pa_id': paperId,
            'pk_id': pkId,
          },
        );
      }
      else {
        response = await _dioClient.getDio().post(
          APIConstants.getChallengeMcqList,
          queryParameters: {
            'crt_chl_id': crtChlId,
          },
        );
      }


      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = ChallengeMcqListResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load MCQs.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load MCQs.',
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

