import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import 'api_constans.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    String baseUrl = APIConstants.baseUrl;

    /// paste your API's baseUrl here...
    final BaseOptions options = BaseOptions(
      sendTimeout: const Duration(milliseconds: 30000),
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      baseUrl: baseUrl,
      /*headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        }*/
    );

    _dio = Dio(options);
    _dio.interceptors.add(AuthorizationInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
  }

  Dio getDio() => _dio;
}

class AuthorizationInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Send user token in headers if it is available

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? token = prefs.getString(AppConstants.token);
    // if (token != null && token.isNotEmpty) {
    //   options.headers['Authorization'] = token;
    // }

    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends InterceptorsWrapper {
  // todo disable for release builds
  final _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(options.path);
    _logger.d(options.queryParameters.toString());
    _logger.d(options.headers.toString());
    _logger.d(options.data);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(response.data);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final errorMessage = err.message;
    final errorData = err.response?.data;
    _logger.e(errorMessage);
    if (errorData != null) {
      _logger.e(errorData);
    }
    // final NavigationService _navigationService = locator<NavigationService>();
    // int? statusCode = err.response?.statusCode;
    // if (statusCode == 401) {
    //   AlertUtils.showToast('Please login again');
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   prefs.clear();
    //   _navigationService.navigateTo(MaterialPageRoute(builder: (context) => WelcomeScreen()));
    // }
    _logger.e(errorMessage);
    if (errorData != null) {
      _logger.e(errorData);
    }
    super.onError(
      err,
      handler,
    );
    super.onError(err, handler);
  }
}
