import 'package:dio/dio.dart';
import 'package:zifour_sourcecode/core/api_client/api_constans.dart';
import 'package:zifour_sourcecode/core/api_client/api_utils.dart';
import 'package:zifour_sourcecode/core/api_client/dio_client.dart';
import 'package:zifour_sourcecode/core/api_models/api_response.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import 'package:zifour_sourcecode/core/utils/user_preference.dart';
import '../model/solution_video_model.dart';

class SolutionVideoRepository {
  SolutionVideoRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<SolutionVideoResponse>> fetchSolutionVideos({
    required String paperId,
    required String subId,
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
        APIConstants.getTestSeriesSolution,
        queryParameters: {
          'stu_id': user.stuId, 
          'g_pa_id': paperId,
          'sub_id': subId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = SolutionVideoResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'No solutions found.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load solutions.',
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

  Future<ApiResponse<ExpertSolutionVideoResponse>> fetchExpertSolutionVideos({
    required String challengeId,
    required String subId,
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
        APIConstants.getExpertSolution,
        queryParameters: {
          'stu_id': user.stuId,
          'crt_chl_id': challengeId,
          'sub_id': subId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = ExpertSolutionVideoResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'No solutions found.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load solutions.',
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
