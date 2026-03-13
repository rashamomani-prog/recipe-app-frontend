import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_recipe_usecase.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart'; // أضيفي هاد الـ Import
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final GetCategories getCategories;
  final AddRecipeUseCase addRecipeUseCase;
  final RecipeRepository recipeRepository; // 1. تعريفه هنا

  // 2. إضافته للـ Constructor
  RecipeCubit(
      this.getCategories,
      this.addRecipeUseCase,
      this.recipeRepository,
      ) : super(RecipeInitial());

  Future<void> fetchRecipes() async {
    emit(RecipeLoading());
    try {
      final categories = await getCategories();
      emit(RecipeLoaded(categories));
    } catch (e) {
      emit(RecipeError("Failed to load: $e"));
    }
  }

  Future<void> addRecipe(RecipeEntity recipe) async {
    try {
      await addRecipeUseCase(recipe);
      await fetchRecipes();
    } catch (e) {
      emit(RecipeError("Failed to add recipe: $e"));
    }
  }

  Future<void> askAI(String question) async {
    emit(RecipeLoading());
    try {
      final result = await recipeRepository.getAIRecommendation(question);
      emit(RecipeAISuccess(result)); // هسا رح تشتغل بس نعدل ملف الـ State
    } catch (e) {
      emit(RecipeError("AI Chef is busy!"));
    }
  }
}