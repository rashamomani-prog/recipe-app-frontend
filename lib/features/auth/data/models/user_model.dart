class UserModel {
  final String email;
  final String token;
  final String role; // هذا الحقل عشان نميز بين الـ Admin والـ User

  UserModel({
    required this.email,
    required this.token,
    required this.role,
  });

  // تحويل البيانات القادمة من JSON (FastAPI) إلى كائن UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      token: json['access_token'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'access_token': token,
      'role': role,
    };
  }
}