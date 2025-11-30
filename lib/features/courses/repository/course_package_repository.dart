import 'package:dio/dio.dart';

import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';
import '../models/course_package.dart';

class CoursePackageRepository {
  CoursePackageRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  final DioClient _dioClient;

  Future<ApiResponse<List<CoursePackage>>> fetchPackages({
    required String studentId,
    required String mediumId,
    required String examId,
  }) async {
    try {
      final response = await _dioClient.getDio().get(
        APIConstants.getPackages,
        queryParameters: {
          'stu_id': studentId,
          'med_id': mediumId,
          'exm_id': examId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['status'] == true) {
          final rawList = (data['package_list'] as List?) ?? [];
          final packages = rawList
              .whereType<Map<dynamic, dynamic>>()
              .map(
                (item) => CoursePackage.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList();

          return ApiResponse.success(data: packages);
        }

        return ApiResponse.error(
          errorMsg: data is Map<String, dynamic>
              ? (data['message'] ?? 'Unable to load packages')
              : 'Unable to load packages',
        );
      }

      return ApiResponse.error(errorMsg: 'Unable to load packages');
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


