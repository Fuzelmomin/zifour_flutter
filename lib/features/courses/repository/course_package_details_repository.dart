import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../../../core/utils/connectivity_helper.dart';
import '../models/course_details_model.dart';
import '../models/course_package.dart';

class CoursePackageDetailsRepository {
  CoursePackageDetailsRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<PackageDetailsItem>> fetchPackageDetails({
    required String packageId,
    required String studentId,
  }) async {
    try {
      final isConnected = await ConnectivityHelper.checkConnectivity();
      if (!isConnected) {
        return ApiResponse.error(
          errorMsg: 'No internet connection. Please check your network.',
        );
      }
      final response = await _dioClient.getDio().get(
        APIConstants.getPackageDetails,
        queryParameters: {
          'pk_id': packageId,
          'stu_id': studentId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final packageData = data['package_list'] as List?;
          
          if (packageData != null && packageData.isNotEmpty) {
            final packageJson = packageData.first;
            if (packageJson is Map) {
              final package = PackageDetailsItem.fromJson(
                Map<String, dynamic>.from(packageJson),
              );

              return ApiResponse.success(data: package);
            }
          }

          return ApiResponse.error(
            errorMsg: data is Map<String, dynamic>
                ? (data['message'] ?? 'Package details not found')
                : 'Package details not found',
          );
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message'] ?? 'Unable to load package details')
              : 'Unable to load package details',
        );
      }

      return ApiResponse.error(
        errorMsg: 'Unable to load package details',
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


