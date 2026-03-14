import '../../data/models/recipe_model.dart';
import '../entities/category_entity.dart';
import '../entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<Recipe>> getRecipes({String? category});
  Future<Recipe> getRecipe(int id);
  Future<void> addRecipe(RecipeEntity recipe);
  Future<Recipe> updateRecipe(int id, RecipeEntity recipe);
  Future<void> deleteRecipe(int id);
  Future<List<Recipe>> getAIRecommendation(String prompt);
  Future<List<Recipe>> searchByIngredients(String items);
  Future<List<Recipe>> searchByQuery(String query);
  Future<bool> toggleFavorite(int recipeId);
  Future<List<Recipe>> getFavorites();
  Future<bool> getFavoriteStatus(int recipeId);
}
