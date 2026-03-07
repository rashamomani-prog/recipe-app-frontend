import '../../../../core/dio_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;
  AuthRemoteDataSource(this.dioClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post('/login', data: {
        'username': email,
        'password': password,
      });
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception("خطأ في تسجيل الدخول: $e");
    }
  }
}