import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/login_model.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../models/home_model.dart';

class HomeRepository {
  HomeRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<HomeResponse>> fetchHomeData() async {
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
        APIConstants.homeData,
        queryParameters: _buildQuery(user),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = HomeResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load home data.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load home data.',
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

  Map<String, dynamic> _buildQuery(LoginData user) {
    return {
      'stu_id': user.stuId,
      'med_id': user.stuMedId,
      'exm_id': _resolveExamId(user),
    };
  }

  String _resolveExamId(LoginData user) {
    if (user.stuExmId != null && user.stuExmId!.isNotEmpty) {
      return user.stuExmId!;
    }
    if (user.stuSubId != null && user.stuSubId!.isNotEmpty) {
      return user.stuSubId!;
    }
    return user.stuStdId;
  }
}

