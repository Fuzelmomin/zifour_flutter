import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/mcq_notes_model.dart';

class McqNotesRepository {
  McqNotesRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<McqNotesResponse>> addMcqNote({
    required String mcqId,
    required String mcqType,
    required String mcqNotesTitle,
    required String mcqNotesDescription,
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
        APIConstants.addMcqNote,
        queryParameters: {
          'stu_id': user.stuId,
          'mcq_id': mcqId,
          'mcq_typ_id': mcqType,
          'mcq_notes_title': mcqNotesTitle,
          'mcq_notes_description': mcqNotesDescription,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = McqNotesResponse.fromJson(
            data as Map<String, dynamic>,
          );
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to add note.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to add note.',
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

