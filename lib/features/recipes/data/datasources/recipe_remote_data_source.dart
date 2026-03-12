import '../../../../core/dio_client.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDataSource {
  final DioClient dioClient;

  RecipeRemoteDataSource(this.dioClient);

  Future<List<Recipe>> getRecipes() async {
    try {
      final response = await dioClient.dio.get('/recipes/');
      return (response.data as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addRecipe(Recipe recipe) async {
    try {
      final response = await dioClient.dio.post(
        '/recipes/',
        data: recipe.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to add recipe to server");
      }
    } catch (e) {
      rethrow;
    }
  }
}