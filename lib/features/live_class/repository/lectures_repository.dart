import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/lectures_model.dart';

class LecturesRepository {
  LecturesRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<LecturesResponse>> getLectures({
    String? chpId,
    String? tpcId,
    String? subId,
    String? stuId,
    String? medId,
    String? exmId,
    String? lvCls,
    String? lecSample,
    String? lecRept,
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

      // Use provided parameters or fallback to user data/defaults
      final queryParams = <String, dynamic>{
        'chp_id': chpId ?? '0',
        'tpc_id': tpcId ?? '0',
        //'sub_id': subId ?? user.stuSubId ?? '1',
        'sub_id': '0',
        'stu_id': stuId ?? user.stuId,
        'med_id': medId ?? user.stuMedId,
        'exm_id': exmId ?? user.stuExmId ?? '1',
        'lv_cls': lvCls ?? '1',
        'lec_sample': lecSample ?? '0',
        'lec_rept': lecRept ?? '0',
      };

      final response = await _dioClient.getDio().get(
        APIConstants.getLectures,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final lecturesResponse = LecturesResponse.fromJson(data);
          return ApiResponse.success(data: lecturesResponse);
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message']?.toString() ?? 'Unable to load lectures')
              : 'Unable to load lectures',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load lectures',
      );
    } on DioException catch (error) {
      final apiError = ApiUtils.getApiError(error);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (error) {
      return ApiResponse.error(
        status: ApiStatus.error,
        errorMsg: 'Unexpected error: ${error.toString()}',
      );
    }
  }
}

