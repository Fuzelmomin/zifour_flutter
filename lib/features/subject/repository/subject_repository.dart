import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/login_model.dart';
import '../../../core/api_models/subject_model.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';

class SubjectRepository {
  SubjectRepository({DioClient? dioClient}) : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<SubjectResponse>> fetchSubjects() async {
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

      final exmId = _getExamId(user);
      // if (exmId == null || exmId.isEmpty) {
      //   return ApiResponse.error(
      //     errorMsg: 'Exam ID not found. Please update your profile.',
      //   );
      // }

      final response = await _dioClient.getDio().get(
        APIConstants.getSubject,
        queryParameters: {
          'exm_id': exmId ?? '1',
        },
      );
      print('Exam Id: ${response.realUri}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = SubjectResponse.fromJson(data as Map<String, dynamic>);
          print('Response Subject: ${model.toJson()}');
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load subjects.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load subjects.',
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

  String? _getExamId(LoginData user) {
    if (user.stuExmId != null && user.stuExmId!.isNotEmpty) {
      return user.stuExmId;
    }
    return null;
  }
}

