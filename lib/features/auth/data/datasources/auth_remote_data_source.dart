import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);
  Future<UserModel> login(String email, String password) async {
    throw UnimplementedError();
  }
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        "/auth/register",
        data: {
          "name": name,
          "email": email,
          "password": password,
        },
      );
      return UserModel.fromJson(response.data);

    } on DioException catch (e) {
      print("Error during registration: ${e.response?.data ?? e.message}");
      throw Exception(e.response?.data['detail'] ?? "Failed to register");
    }
  }
}