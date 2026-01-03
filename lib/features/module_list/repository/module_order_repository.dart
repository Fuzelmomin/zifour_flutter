import 'package:dio/dio.dart';
import 'package:zifour_sourcecode/core/api_client/api_constans.dart';
import 'package:zifour_sourcecode/core/api_client/api_utils.dart';
import 'package:zifour_sourcecode/core/api_client/dio_client.dart';
import 'package:zifour_sourcecode/core/api_models/api_response.dart';
import 'package:zifour_sourcecode/core/utils/connectivity_helper.dart';
import '../model/module_order_model.dart';

class ModuleOrderRepository {
  final DioClient _dioClient;

  ModuleOrderRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<ApiResponse<ModuleOrderResponse>> submitModuleOrder({
    required String stuId,
    required String mdlId,
    required String name,
    required String mobile,
    required String pincode,
    required String address,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }

      final response = await _dioClient.getDio().post(
            APIConstants.moduleOrderContact,
            queryParameters: {
              'stu_id': stuId,
              'mdl_id': mdlId,
              'mdls_tr_name': name,
              'mdls_tr_mobile': mobile,
              'mdls_pincode': pincode,
              'mdls_tr_address': address,
            },
          );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final model = ModuleOrderResponse.fromJson(data as Map<String, dynamic>);
          return ApiResponse.success(data: model);
        }
        return ApiResponse.error(
          errorMsg: data['message']?.toString() ?? 'Unable to submit order.',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to submit order.',
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
