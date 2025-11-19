import 'dart:io';
import 'package:dio/dio.dart';
import '../api_client/api_constans.dart';
import '../api_client/dio_client.dart';
import '../api_client/api_utils.dart';
import '../api_models/standard_model.dart';
import '../api_models/exam_model.dart';
import '../api_models/image_upload_model.dart';
import '../api_models/send_otp_model.dart';
import '../api_models/verify_otp_model.dart';
import '../api_models/api_response.dart';
import '../api_models/api_status.dart';

class SignupRepository {
  final DioClient _dioClient = DioClient();

  /// Fetch standards list
  Future<ApiResponse<StandardResponse>> fetchStandards() async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.getStandard,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final standardResponse = StandardResponse.fromJson(data);
          return ApiResponse.success(data: standardResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to fetch standards',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to fetch standards',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e, stack) {
      print(stack);
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Fetch exams list
  Future<ApiResponse<ExamResponse>> fetchExams() async {
    try {
      final response = await _dioClient.getDio().post(
        APIConstants.getExam,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final examResponse = ExamResponse.fromJson(data);
          return ApiResponse.success(data: examResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to fetch exams',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to fetch exams',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e, stack) {
      print(stack);
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Upload image
  Future<ApiResponse<ImageUploadResponse>> uploadImage({
    required File imageFile,
  }) async {
    try {
      // Get file extension and ensure it's lowercase
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      
      // Validate file extension
      if (fileExtension != 'jpg' && fileExtension != 'jpeg' && fileExtension != 'png') {
        return ApiResponse.error(
          errorMsg: 'This file extension is not allowed. Please upload a JPEG or PNG file',
        );
      }

      // Only send the file with parameter name 'the_file' as per API requirement
      final formData = FormData.fromMap({
        'the_file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _dioClient.getDio().post(
        APIConstants.imageUpload,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final imageUploadResponse = ImageUploadResponse.fromJson(data);
          return ApiResponse.success(data: imageUploadResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to upload image',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to upload image',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Convert gender string to number as per API requirement
  String _convertGenderToNumber(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return '1';
      case 'female':
        return '2';
      case 'other':
        return '3';
      default:
        return '1'; // Default to Male
    }
  }

  /// Send OTP
  Future<ApiResponse<SendOtpResponse>> sendOTP({
    required String name,
    required String stdId,
    required String exmId,
    required String password,
    required String mobile,
    required String imageUrl,
    String? gender,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.sendOTP,
        queryParameters: {
          'stu_name': name,
          'stu_std_id': stdId,
          'stu_exm_id': exmId,
          'stu_password': password,
          'stu_mobile': mobile,
          'stu_document': imageUrl,
          if (gender != null) 'stu_gender': _convertGenderToNumber(gender),
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          try {
            // Handle nested data structure if present
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            if (data['data'] != null && data['data'] is Map) {
              // Merge nested data into root for model parsing
              final nestedData = data['data'] as Map<String, dynamic>;
              responseData = {
                ...responseData,
                ...nestedData,
              };
            }
            final sendOtpResponse = SendOtpResponse.fromJson(responseData);
            return ApiResponse.success(data: sendOtpResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to send OTP') : 'Failed to send OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to send OTP',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Resend OTP
  Future<ApiResponse<SendOtpResponse>> resendOTP({
    required String mobile,
  }) async {
    try {
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.reSendOTP,
        queryParameters: {
          'stu_mobile': mobile,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          try {
            // Handle nested data structure if present
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            if (data['data'] != null && data['data'] is Map) {
              // Merge nested data into root for model parsing
              final nestedData = data['data'] as Map<String, dynamic>;
              responseData = {
                ...responseData,
                ...nestedData,
              };
            }
            final sendOtpResponse = SendOtpResponse.fromJson(responseData);
            return ApiResponse.success(data: sendOtpResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to resend OTP') : 'Failed to resend OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to resend OTP',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Verify OTP
  Future<ApiResponse<VerifyOtpResponse>> verifyOTP({
    required String stuVerification,
    required String stuMobile,
  }) async {
    try {
      final response = await _dioClient.getDio().get(
        APIConstants.verification,
        queryParameters: {
          'stu_verification': stuVerification,
          'stu_mobile': stuMobile,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final verifyOtpResponse = VerifyOtpResponse.fromJson(data);
          return ApiResponse.success(data: verifyOtpResponse);
        } else {
          return ApiResponse.error(
            errorMsg: data['message'] ?? 'Failed to verify OTP',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to verify OTP',
        );
      }
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiError(e);
      return ApiResponse.error(
        error: apiError,
        errorMsg: apiError.getFirstError() ?? 'Network error occurred',
      );
    } catch (e) {
      return ApiResponse.error(
        errorMsg: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}

