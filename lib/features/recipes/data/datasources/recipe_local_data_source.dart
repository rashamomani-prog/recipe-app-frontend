import '../../domain/entities/recipe_entity.dart';

abstract class RecipeLocalDataSource {
  Future<void> addRecipe(RecipeEntity recipe);
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {

  @override
  Future<void> addRecipe(RecipeEntity recipe) async {
    print("Recipe added to local storage: ${recipe.title}");
  }
}