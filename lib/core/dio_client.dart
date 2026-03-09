import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;
  Dio get dio => _dio;

  static const String baseUrl = "http://192.168.1.12:8000/register";

  DioClient()
      : _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      responseType: ResponseType.json,
      contentType: 'application/json',
    ),
  );

}