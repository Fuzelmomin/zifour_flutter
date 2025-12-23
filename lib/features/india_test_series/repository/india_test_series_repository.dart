import 'package:dio/dio.dart';
import 'package:zifour_sourcecode/core/api_client/api_constans.dart';
import 'package:zifour_sourcecode/core/api_client/api_utils.dart';
import 'package:zifour_sourcecode/core/api_client/dio_client.dart';
import 'package:zifour_sourcecode/core/api_models/api_response.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/features/india_test_series/model/online_test_paper_model.dart';

class IndiaTestSeriesRepository {
  final DioClient _dioClient;

  IndiaTestSeriesRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<ApiResponse<OnlineTestPaperResponse>> fetchOnlineTestPapers(String pkId) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().post(
        APIConstants.getOnlineTestPaper,
        queryParameters: {
          'pk_id': pkId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = OnlineTestPaperResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load test papers.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load test papers.',
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
