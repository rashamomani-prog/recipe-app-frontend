import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.6:8000";

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes/'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
        return body.map((item) => Recipe.fromJson(item)).toList();
      } else {
        throw "خطأ في السيرفر: ${response.statusCode}";
      }
    } catch (e) {
      throw "تأكد من تشغيل السيرفر والـ IP: $e";
    }
  }

  Future<bool> addRecipe(String title, String ingredients, String instructions, String category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recipes/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "ingredients": ingredients,
        "instructions": instructions,
        "category": category,
        "owner_id": 1
      }),
    );
    return response.statusCode == 200;
  }
}