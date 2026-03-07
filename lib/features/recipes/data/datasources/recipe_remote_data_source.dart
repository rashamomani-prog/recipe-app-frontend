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
}