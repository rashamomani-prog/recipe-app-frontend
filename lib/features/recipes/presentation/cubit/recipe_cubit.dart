import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import 'recipe_state.dart';
import '../../domain/entities/category_entity.dart';
class RecipeCubit extends Cubit<RecipeState> {
  final GetCategories getCategories;

  RecipeCubit(this.getCategories) : super(RecipeInitial());

  Future<void> fetchRecipes() async {
    emit(RecipeLoading());
    try {
      final categories = await getCategories();
      emit(RecipeLoaded(categories));
    } catch (e) {
      emit(RecipeError("Failed to load: $e"));
    }
  }
}