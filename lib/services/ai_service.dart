import 'package:dio/dio.dart';
import '../core/api_config.dart';
import '../features/recipes/data/models/recipe_model.dart';

class AIService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: kBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    contentType: 'application/json',
  ));

  /// POST /ai/predict — natural language recipe recommendations
  Future<List<Recipe>> predict(String text) async {
    try {
      final response = await _dio.post<List>(
        '/ai/predict',
        data: {'text': text},
      );
      final list = response.data;
      if (list == null) return [];
      return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception(e.response?.data?['detail'] ?? 'No recipes found.');
      }
      throw Exception(e.response?.data?['detail'] ?? e.message ?? 'AI suggestion failed');
    }
  }

  /// Alias for backward compatibility
  static Future<List<Recipe>> findRecipesByIngredients(String ingredientsOrQuery) async {
    final service = AIService();
    return service.predict(ingredientsOrQuery);
  }
}
