import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  /// POST /auth/register — returns { "message": "User created successfully" }
  Future<void> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode != 200) {
        throw Exception(response.data?['detail'] ?? 'Failed to register');
      }
    } on DioException catch (e) {
      final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
      throw Exception(detail?.toString() ?? e.message ?? 'Failed to register');
    }
  }

  /// POST /auth/login — returns { "access_token": "...", "token_type": "bearer" }
  Future<String> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final data = response.data as Map<String, dynamic>?;
      final token = data?['access_token'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('Invalid response from server');
      }
      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Invalid credentials');
      }
      final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
      throw Exception(detail?.toString() ?? e.message ?? 'Login failed');
    }
  }

  /// GET /auth/me — returns { id, name, email, role }
  Future<UserModel> getMe() async {
    try {
      final response = await dio.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Could not validate credentials');
      }
      rethrow;
    }
  }
}
