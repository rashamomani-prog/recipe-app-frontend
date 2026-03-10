import '../models/recipe_model.dart';

class RecipeRepository {
  static final List<Recipe> allRecipes = [
    // --- Breakfast ---
    Recipe(
      id: 1,
      title: 'Avocado Toast 🥑',
      category: 'Breakfast',
      ingredients: '1 slice bread, 1/2 avocado, egg...',
      instructions: '1. Toast bread. 2. Mash avocado...',
      calories: 320,
      time: 5,
      imagePath: 'assets/images/avocado.jpg',
      isFavorite: false,
    ),
    Recipe(
      id: 2,
      title: 'Yogurt Fruit Bowl 🍯',
      category: 'Breakfast',
      ingredients: 'Yogurt, Fruits, Honey...',
      instructions: '1. Place yogurt. 2. Add fruits...',
      calories: 180,
      time: 3,
      imagePath: 'assets/images/yogurt_bowl.jpg',
      isFavorite: false,
    ),
    Recipe(
      id: 4,
      title: 'Jordanian Mansaf 🍖',
      category: 'Lunch',
      ingredients: 'Lamb, Jameed, Rice...',
      instructions: '1. Cook meat in jameed...',
      calories: 920,
      time: 75,
      imagePath: 'assets/images/mansaf.jpg',
      isFavorite: false,
    ),
  ];
  static List<Recipe> getFavoriteRecipes() {
    return allRecipes.where((r) => r.isFavorite).toList();
  }
}