import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async => await _storage.write(key: 'jwt_token', value: token);
  Future<void> saveRole(String role) async => await _storage.write(key: 'user_role', value: role);
  Future<String?> getToken() async => await _storage.read(key: 'jwt_token');
  Future<String?> getRole() async => await _storage.read(key: 'user_role');
  Future<void> clearAuthData() async => await _storage.deleteAll();
}