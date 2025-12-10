import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/submit_mcq_answer_model.dart';

class SubmitMcqAnswerRepository {
  SubmitMcqAnswerRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<SubmitMcqAnswerResponse>> submitMcqAnswer({
    required int crtChlId,
    required List<Map<String, String>> mcqList,
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

      final response = await _dioClient.getDio().post(
        APIConstants.submitMcqAnswer,
        queryParameters: {
          'stu_id': user.stuId,
          'crt_chl_id': crtChlId,
          'mcq_list': jsonEncode(mcqList),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true || data['message'] != null) {
          final model = SubmitMcqAnswerResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to submit answers.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to submit answers.',
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

