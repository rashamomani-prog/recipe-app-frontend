import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // حفظ الـ Token والـ Role
  Future<void> saveToken(String token) async => await _storage.write(key: 'jwt_token', value: token);
  Future<void> saveRole(String role) async => await _storage.write(key: 'user_role', value: role);

  // قراءة البيانات
  Future<String?> getToken() async => await _storage.read(key: 'jwt_token');
  Future<String?> getRole() async => await _storage.read(key: 'user_role');

  // مسح البيانات عند تسجيل الخروج
  Future<void> clearAuthData() async => await _storage.deleteAll();
}