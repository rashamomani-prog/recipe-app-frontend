import 'package:dio/dio.dart';
import '../../../../core/dio_client.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDataSource {
  final DioClient dioClient;

  RecipeRemoteDataSource(this.dioClient);

  Dio get _dio => dioClient.dio;

  /// GET /recipes/{id} — get single recipe (optional; backend may not have this).
  Future<Recipe> getRecipe(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/recipes/$id');
      final data = response.data;
      if (data == null) throw Exception('Recipe not found');
      return Recipe.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Recipe not found');
      }
      final data = e.response?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      throw Exception(detail?.toString() ?? e.message ?? 'Failed to load recipe');
    }
  }

  /// GET /recipes/?category=...
  Future<List<Recipe>> getRecipes({String? category}) async {
    try {
      final response = await _dio.get<List>(
        '/recipes/',
        queryParameters: category != null && category.isNotEmpty ? {'category': category} : null,
      );
      final list = response.data;
      if (list == null) return [];
      return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['detail'] ?? e.message ?? 'Failed to load recipes');
    }
  }

  /// GET /recipes/search?items=chicken,salt
  Future<List<Recipe>> searchByIngredients(String items) async {
    try {
      final response = await _dio.get<List>('/recipes/search', queryParameters: {'items': items});
      final list = response.data;
      if (list == null) return [];
      return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['detail'] ?? e.message ?? 'Search failed');
    }
  }

  /// GET /recipes/by-query?query=...
  Future<List<Recipe>> searchByQuery(String query) async {
    try {
      final response = await _dio.get<List>('/recipes/by-query', queryParameters: {'query': query});
      final list = response.data;
      if (list == null) return [];
      return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['detail'] ?? e.message ?? 'Search failed');
    }
  }

  /// GET /recipes/favorites — list recipes the current user has favorited. Auth required.
  Future<List<Recipe>> getFavorites() async {
    try {
      final response = await _dio.get<List>('/recipes/favorites');
      final list = response.data;
      if (list == null) return [];
      return list.map((e) => Recipe.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      if (e.response?.statusCode == 401) {
        throw Exception('Please log in to see your favorites.');
      }
      throw Exception(detail?.toString() ?? e.message ?? 'Failed to load favorites');
    }
  }

  /// GET /recipes/{id}/favorite — whether current user has this recipe favorited. Auth optional.
  /// Returns false if no token or invalid token.
  Future<bool> getFavoriteStatus(int recipeId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/recipes/$recipeId/favorite');
      final data = response.data;
      if (data == null) return false;
      return data['favorited'] as bool? ?? false;
    } on DioException catch (_) {
      return false;
    }
  }

  /// POST /recipes/{recipe_id}/favorite — toggle favorite (auth required).
  /// Response 200: { "status": "favorited" | "unfavorited", "message": "..." }
  /// Returns true if recipe is now favorited, false if unfavorited.
  Future<bool> toggleFavorite(int recipeId) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>('/recipes/$recipeId/favorite');
      final data = response.data;
      if (data == null) return false;
      final status = data['status']?.toString().toLowerCase() ?? '';
      return status == 'favorited';
    } on DioException catch (e) {
      final res = e.response;
      final data = res?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      final message = detail?.toString() ?? e.message ?? 'Failed to update favorite';
      if (res?.statusCode == 401) {
        throw Exception('Please log in to add favorites.');
      }
      throw Exception(message);
    }
  }

  /// POST /admin/recipes — create recipe (admin only).
  /// Requires: Authorization Bearer <token>. User must be admin (e.g. admin@example.com).
  /// Request: RecipeBase — title, ingredients, instructions (required); image_url, category (optional).
  /// Response 200: RecipeOut — id, owner_id, title, ingredients, instructions, image_url, category.
  /// 401: Could not validate credentials. 403: Not allowed.
  Future<Recipe> addRecipe({
    required String title,
    required String ingredients,
    required String instructions,
    String? imageUrl,
    String? category,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'ingredients': ingredients,
        'instructions': instructions,
      };
      if (imageUrl != null && imageUrl.isNotEmpty) {
        body['image_url'] = imageUrl;
      } else {
        body['image_url'] = null;
      }
      if (category != null && category.isNotEmpty) {
        body['category'] = category;
      } else {
        body['category'] = null;
      }

      final response = await _dio.post<Map<String, dynamic>>(
        '/admin/recipes',
        data: body,
      );
      final data = response.data;
      if (data == null) throw Exception('Invalid response');
      return Recipe.fromJson(data);
    } on DioException catch (e) {
      final response = e.response;
      final status = response?.statusCode;
      final data = response?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      final message = detail?.toString() ?? e.message ?? 'Failed to add recipe';

      if (status == 401) {
        throw Exception('Could not validate credentials. Please log in again.');
      }
      if (status == 403) {
        throw Exception('Not allowed. Only admin (e.g. admin@example.com) can create recipes.');
      }
      throw Exception(message);
    }
  }

  /// PUT /admin/recipes/{id} — update recipe (admin only). Body: RecipeBase.
  Future<Recipe> updateRecipe(
    int id, {
    required String title,
    required String ingredients,
    required String instructions,
    String? imageUrl,
    String? category,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'ingredients': ingredients,
        'instructions': instructions,
        'image_url': imageUrl,
        'category': category,
      };
      final response = await _dio.put<Map<String, dynamic>>('/admin/recipes/$id', data: body);
      final data = response.data;
      if (data == null) throw Exception('Invalid response');
      return Recipe.fromJson(data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      final message = detail?.toString() ?? e.message ?? 'Failed to update recipe';
      if (status == 401) throw Exception('Could not validate credentials.');
      if (status == 403) throw Exception('Not allowed. Only admin can edit recipes.');
      if (status == 404) throw Exception('Recipe not found.');
      throw Exception(message);
    }
  }

  /// DELETE /admin/recipes/{id} — delete recipe (admin only).
  Future<void> deleteRecipe(int id) async {
    try {
      await _dio.delete('/admin/recipes/$id');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final detail = data is Map ? (data as Map)['detail'] : null;
      final message = detail?.toString() ?? e.message ?? 'Failed to delete recipe';
      if (status == 401) throw Exception('Could not validate credentials.');
      if (status == 403) throw Exception('Not allowed. Only admin can delete recipes.');
      if (status == 404) throw Exception('Recipe not found.');
      throw Exception(message);
    }
  }
}
