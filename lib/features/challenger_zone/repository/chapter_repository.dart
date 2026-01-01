import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/login_model.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/chapter_model.dart';

class ChapterRepository {
  ChapterRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<ChapterResponse>> fetchChapters({
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
        APIConstants.getChapters,
        queryParameters: {
          'stu_id': user.stuId,
          'sub_id': subId,
          'std_id': user.stuStdId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final List<dynamic> chapterListJson = data['chapter_list'] ?? [];
          final chapters = chapterListJson.map((json) {
            final chapter = ChapterModel.fromJson(json as Map<String, dynamic>);
            return chapter.copyWith(subId: subId);
          }).toList();

          return ApiResponse.success(
            data: ChapterResponse(
              status: true,
              message: data['message']?.toString() ?? 'Success',
              chapterList: chapters,
            ),
          );
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'No chapters found.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load chapters.',
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

