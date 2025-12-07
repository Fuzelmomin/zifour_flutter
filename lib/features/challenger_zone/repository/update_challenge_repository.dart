import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/update_challenge_model.dart';

class UpdateChallengeRepository {
  UpdateChallengeRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<UpdateChallengeResponse>> updateChallenge({
    required int crtChlId,
    required List<String> chapterIds,
    required List<String> topicIds,
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

      final chaptersParam = _encodeIdList(chapterIds);
      final topicsParam = _encodeIdList(topicIds);

      final response = await _dioClient.getDio().post(
        APIConstants.updateChallenge,
        queryParameters: {
          'crt_chl_id': crtChlId,
          'stu_id': user.stuId,
          'chapters': chaptersParam,
          'topics': topicsParam,
          'sub_id': subId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = UpdateChallengeResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg:
              data['message']?.toString() ?? 'Unable to update challenge.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to update challenge.',
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

  String _encodeIdList(List<String> ids) {
    if (ids.isEmpty) return '[]';
    return '[${ids.join(',')}]';
  }
}

