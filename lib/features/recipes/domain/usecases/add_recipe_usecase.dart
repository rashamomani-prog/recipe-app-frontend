import '../entities/recipe_entity.dart';
import '../repositories/recipe_repository.dart';

class AddRecipeUseCase {
  final RecipeRepository repository;

  AddRecipeUseCase(this.repository);

  Future<void> call(RecipeEntity recipe) async {
    return await repository.addRecipe(recipe);
  }
}