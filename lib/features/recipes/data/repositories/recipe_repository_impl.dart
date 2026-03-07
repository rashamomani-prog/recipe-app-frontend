import '../datasources/recipe_remote_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepository(this.remoteDataSource);

  Future<List<Recipe>> getAllRecipes() {
    return remoteDataSource.getRecipes();
  }
}