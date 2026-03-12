import '../../data/models/recipe_model.dart';
import '../../domain/entities/recipe_entity.dart';

abstract class RecipeLocalDataSource {
  Future<void> addRecipe(RecipeEntity recipe);
// إذا عندك دوال ثانية مثل getSavedRecipes حطيها هون
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  // هون عادة بيكون عندك كود الـ Sqflite أو الـ SharedPreferences
  // بس حالياً رح نخليه بسيط عشان يشتغل التطبيق بدون إيرورز

  @override
  Future<void> addRecipe(RecipeEntity recipe) async {
    // كود إضافة الوصفة لقاعدة البيانات
    print("Recipe added to local storage: ${recipe.title}");
  }
}