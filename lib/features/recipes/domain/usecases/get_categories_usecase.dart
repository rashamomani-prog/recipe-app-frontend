import '../entities/category_entity.dart';
import '../repositories/recipe_repository.dart';

class GetCategories {
  final RecipeRepository repository;

  GetCategories(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}