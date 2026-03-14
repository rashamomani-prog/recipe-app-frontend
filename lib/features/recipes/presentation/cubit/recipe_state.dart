import '../../data/models/recipe_model.dart';
import '../../domain/entities/category_entity.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}
class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<CategoryEntity> result;
  RecipeLoaded(this.result);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}

class RecipeAISuccess extends RecipeState {
  final List<Recipe> recipes;
  RecipeAISuccess(this.recipes);
}

class RecipeAddSuccess extends RecipeState {}
