class UserModel {
  final int id;
  final String name;
  final String email;
  final String? token;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.role,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      token: json['token'],
      role: json['role'],
    );
  }
}