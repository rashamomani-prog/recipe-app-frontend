import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/recipes/data/models/recipe_model.dart';

class AIService {
  static Future<List<Recipe>> findRecipesByIngredients(String ingredients) async {
    try {
      final url = Uri.parse('http://192.168.1.XX:8000/ai/predict');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': ingredients}),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      print("AI Error: $e");
      return [];
    }
  }
}