import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../../../core/utils/user_preference.dart';
import '../model/revision_model.dart';
import 'package:dio/dio.dart';

class RevisionRepository {
  final DioClient _dioClient;

  RevisionRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<ApiResponse<RevisionResponse>> fetchRevisionList() async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
            errorMsg: 'No internet connection. Please check your network.');
      }

      final userData = await UserPreference.getUserData();
      if (userData == null) {
        return ApiResponse.error(errorMsg: 'User data not found.');
      }

      final response = await _dioClient.getDio().get(
        APIConstants.getPlannerList,
        queryParameters: {
          'stu_id': userData.stuId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return ApiResponse.success(data: RevisionResponse.fromJson(data));
        }
        return ApiResponse.error(errorMsg: data['message']?.toString() ??
            'Unable to fetch revision list.');
      }

      return ApiResponse.error(errorMsg: 'Unable to fetch revision list.');
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred.',
      );
    } catch (e) {
      return ApiResponse.error(errorMsg: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<ApiResponse<bool>> deleteRevision(String plnrId) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
            errorMsg: 'No internet connection. Please check your network.');
      }

      final userData = await UserPreference.getUserData();
      if (userData == null) {
        return ApiResponse.error(errorMsg: 'User data not found.');
      }

      final response = await _dioClient.getDio().post(
        APIConstants.deletePlanner,
        queryParameters: {
          'stu_id': userData.stuId,
          'plnr_id': plnrId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return ApiResponse.success(data: data['status'] == true);
      }
      return ApiResponse.error(errorMsg: 'Unable to delete revision.');
    } catch (e) {
      return ApiResponse.error(errorMsg: 'Unexpected error: ${e.toString()}');
    }
  }

  Future<ApiResponse<String>> submitRevision({
    required String stdId,
    required String exmId,
    required List<String> subId,
    required String medId,
    required List<String> chpId,
    required List<String> tpcId,
    required String sDate, // YYYY-MM-DD
    required String eDate, // YYYY-MM-DD
    required String dHours,
    required String message,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
            errorMsg: 'No internet connection. Please check your network.');
      }

      final userData = await UserPreference.getUserData();
      if (userData == null) {
        return ApiResponse.error(errorMsg: 'User data not found.');
      }

      final response = await _dioClient.getDio().post(
        APIConstants.createPlannerSubmit,
        queryParameters: {
          'stu_id': userData.stuId,
          'std_id': stdId,
          'exm_id': exmId,
          'sub_id': _encodeIdList(subId),
          'med_id': medId,
          'chp_id': _encodeIdList(chpId),
          'tpc_id': _encodeIdList(tpcId),
          'plnr_sdate': sDate,
          'plnr_edate': eDate,
          'plnr_dhours': dHours,
          'plnr_message': message,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          return ApiResponse.success(data: data['message']?.toString() ??
              'Revision submitted successfully.');
        }
        return ApiResponse.error(errorMsg: data['message']?.toString() ??
            'Unable to submit revision.');
      }
      return ApiResponse.error(errorMsg: 'Unable to submit revision.');
    } catch (e) {
      return ApiResponse.error(errorMsg: 'Unexpected error: ${e.toString()}');
    }
  }

  String _encodeIdList(List<String> ids) {
    if (ids.isEmpty) return '[]';
    return '[${ids.join(',')}]';
  }
}


