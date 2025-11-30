import 'dart:io';
import 'package:dio/dio.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api_client/api_constans.dart';
import '../../../core/api_client/dio_client.dart';
import '../../../core/api_client/api_utils.dart';
import '../../../core/api_models/login_model.dart';
import '../../../core/api_models/api_response.dart';
import '../../../core/api_models/api_status.dart';

class LoginRepository {
  final DioClient _dioClient = DioClient();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  static const String _deviceIdKey = 'device_id';

  /// Get device ID - store and retrieve from SharedPreferences
  Future<String> _getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);
      
      if (deviceId == null || deviceId.isEmpty) {
        // Get actual device ID based on platform
        if (Platform.isAndroid) {
          final androidInfo = await _deviceInfo.androidInfo;
          deviceId = androidInfo.id;
        } else if (Platform.isIOS) {
          final iosInfo = await _deviceInfo.iosInfo;
          deviceId = iosInfo.identifierForVendor ?? '';
        } else {
          // Fallback for other platforms
          deviceId = '${DateTime.now().millisecondsSinceEpoch}';
        }
        
        // Store the device ID for future use
        if (deviceId.isNotEmpty) {
          await prefs.setString(_deviceIdKey, deviceId);
        }
      }
      
      return deviceId;
    } catch (e) {
      // Fallback to timestamp-based ID if device info fails
      try {
        final prefs = await SharedPreferences.getInstance();
        final fallbackId = '${DateTime.now().millisecondsSinceEpoch}';
        await prefs.setString(_deviceIdKey, fallbackId);
        return fallbackId;
      } catch (e2) {
        return '${DateTime.now().millisecondsSinceEpoch}';
      }
    }
  }

  /// Login user
  Future<ApiResponse<LoginResponse>> login({
    required String mobile,
    required String password,
  }) async {
    try {
      // Get device ID
      final deviceId = await _getDeviceId();
      
      // Use query parameters as per API requirement (shown in the image)
      final response = await _dioClient.getDio().post(
        APIConstants.loginApi,
        queryParameters: {
          'stu_mobile': mobile,
          'stu_password': password,
          'device_id': deviceId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['status'] == true) {
          // Check if account is active before parsing full data
          final isActive = data['is_active'] as bool? ?? true;
          final message = data['message']?.toString() ?? 'Please activate your account';
          
          if (!isActive) {
            // Account is not active, return error with message
            return ApiResponse.error(
              errorMsg: message,
            );
          }
          
          // Account is active, parse full response
          try {
            // Convert Map<dynamic, dynamic> to Map<String, dynamic>
            Map<String, dynamic> responseData = Map<String, dynamic>.from(data);
            final loginResponse = LoginResponse.fromJson(responseData);
            return ApiResponse.success(data: loginResponse);
          } catch (e) {
            return ApiResponse.error(
              errorMsg: 'Error parsing response: ${e.toString()}',
            );
          }
        } else {
          return ApiResponse.error(
            errorMsg: data is Map ? (data['message'] ?? 'Failed to login') : 'Failed to login',
          );
        }
      } else {
        return ApiResponse.error(
          errorMsg: 'Failed to login',
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

