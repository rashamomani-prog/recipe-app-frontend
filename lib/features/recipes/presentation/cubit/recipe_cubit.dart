import 'package:flutter_bloc/flutter_bloc.dart';
import 'recipe_state.dart';
import '../../data/repositories/recipe_repository_impl.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final RecipeRepository repository;

  RecipeCubit(this.repository) : super(RecipeInitial());

  Future<void> fetchRecipes() async {
    emit(RecipeLoading());
    try {
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("عذراً، فشل الاتصال بالسيرفر: $e"));
    }
  }
}