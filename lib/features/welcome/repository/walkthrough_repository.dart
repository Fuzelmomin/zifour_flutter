import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/language_preference.dart';
import '../../../core/utils/user_preference.dart';
import '../model/walkthrough_model.dart';

class WalkthroughRepository {
  WalkthroughRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<WalkthroughResponse>> fetchWalkthrough({
    String? medId,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      // String finalMedId = medId ?? '2';
      //
      // final user = await UserPreference.getUserData();
      // if (user != null && user.stuMedId.isNotEmpty && user.stuMedId != '0') {
      //   finalMedId = user.stuMedId;
      // }
      final finalMedId = await LanguagePreference.getSelectedMediumId() ?? '2';

      final response = await _dioClient.getDio().get(
        APIConstants.getWelcomeImages,
        queryParameters: {
          'med_id': finalMedId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final walkthroughResponse =
              WalkthroughResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: walkthroughResponse);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to load walkthrough images.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load walkthrough images.',
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

