import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/mcq_type_model.dart';
import '../../../core/utils/connectivity_helper.dart';

class McqTypeRepository {
  McqTypeRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<McqTypeResponse>> fetchMcqTypes() async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().get(
        APIConstants.getMCQTypes,
      );
      print('MCQ Types API: ${response.realUri}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = McqTypeResponse.fromJson(data as Map<String, dynamic>);
          print('Response MCQ Types: ${model.toJson()}');
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load MCQ types.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load MCQ types.',
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
