import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/topic_wise_report_model.dart';

class TopicWiseReportRepository {
  TopicWiseReportRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<TopicWiseReportModel>> fetchTopicWiseReport(String topicId) async {
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

      final response = await _dioClient.getDio().get(
        APIConstants.getTopicWiseReport,
        queryParameters: {
          'stu_id': user.stuId,
          'tpc_id': topicId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = await compute(_parseTopicWiseReport, data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load topic report.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load topic report.',
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

// Top-level function for compute
TopicWiseReportModel _parseTopicWiseReport(Map<String, dynamic> json) {
  return TopicWiseReportModel.fromJson(json);
}
