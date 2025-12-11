import 'dart:io';
import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/api_models/image_upload_model.dart';
import '../../../core/repositories/signup_repository.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../model/doubt_submit_model.dart';

class DoubtRepository {
  DoubtRepository({DioClient? dioClient, SignupRepository? signupRepository})
      : _dioClient = dioClient ?? DioClient(),
        _signupRepository = signupRepository ?? SignupRepository();

  final DioClient _dioClient;
  final SignupRepository _signupRepository;

  /// Upload image for doubt attachment
  Future<ApiResponse<ImageUploadResponse>> uploadImage({
    required File imageFile,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      return await _signupRepository.uploadImage(imageFile: imageFile);
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Submit doubt
  Future<ApiResponse<DoubtSubmitResponse>> submitDoubt({
    required String stuId,
    required String stdId,
    required String exmId,
    required String subId,
    required String medId,
    required String dbtMessage,
    String? dbtAttachment,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final queryParams = <String, dynamic>{
        'stu_id': stuId,
        'std_id': stdId,
        'exm_id': exmId,
        'sub_id': subId,
        'med_id': medId,
        'dbt_message': dbtMessage,
        if (dbtAttachment != null && dbtAttachment.isNotEmpty)
          'dbt_attachment': dbtAttachment,
      };

      final response = await _dioClient.getDio().post(
        APIConstants.createDoubtSubmit,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final doubtSubmitResponse = DoubtSubmitResponse.fromJson(data);
          return ApiResponse.success(data: doubtSubmitResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message']?.toString() ?? 'Failed to submit doubt',
          );
        }
      }

      return ApiResponse.error(
        errorMsg: 'Failed to submit doubt',
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

