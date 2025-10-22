import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../api_models/api_error.dart';

class ApiUtils {
  ApiUtils._();

  static ApiError getApiError(DioException error) {
    final response = error.response;

    debugPrint('RESPONSE_ERRRORR ${error.response}');
    debugPrint('RESPONSE_ERRRORR ${response!.data['message']}');

    final data = response.data;
    if (data != null) {
      return ApiError.fromJson(data);
    } else {
      debugPrint('RESPONSE_ERRRORRMM ${error.message}');
      return ApiError.fromMessage(error.message.toString());
    }
  }
}
