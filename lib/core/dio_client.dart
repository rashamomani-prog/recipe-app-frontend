import 'package:dio/dio.dart';
import 'api_config.dart';
import 'auth_local_service.dart';

class DioClient {
  final AuthLocalService _authLocalService;
  late final Dio _dio;
  Dio get dio => _dio;

  DioClient(this._authLocalService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: kBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        contentType: 'application/json',
      ),
    );
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authLocalService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }
}
