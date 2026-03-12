import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_recipe_usecase.dart';
import '../../domain/entities/recipe_entity.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final GetCategories getCategories;
  final AddRecipeUseCase addRecipeUseCase;

  RecipeCubit(this.getCategories, this.addRecipeUseCase) : super(RecipeInitial());

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

      // بعد الإضافة، يفضل تحديث القائمة (اختياري)
      await fetchRecipes();
    } catch (e) {
      emit(RecipeError("Failed to add recipe: $e"));
    }
  }
}