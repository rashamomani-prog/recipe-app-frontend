import 'package:flutter/material.dart';
import '../../../../services/ai_service.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import '../datasources/recipe_remote_data_source.dart';
import '../models/recipe_model.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;
  final RecipeLocalDataSource localDataSource;
  final AIService aiService;

  RecipeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.aiService,
  });

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return [
      CategoryEntity(id: '1', title: 'Breakfast', icon: Icons.breakfast_dining, accentColor: Colors.orange),
      CategoryEntity(id: '2', title: 'Lunch', icon: Icons.lunch_dining, accentColor: Colors.red),
      CategoryEntity(id: '3', title: 'Dinner', icon: Icons.dinner_dining, accentColor: Colors.blue),
      CategoryEntity(id: '4', title: 'Salads', icon: Icons.flatware, accentColor: Colors.green),
      CategoryEntity(id: '5', title: 'Appetizers', icon: Icons.tapas, accentColor: Colors.brown),
      CategoryEntity(id: '6', title: 'Desserts', icon: Icons.icecream_outlined, accentColor: Colors.pink),
      CategoryEntity(id: '7', title: 'Drinks', icon: Icons.local_cafe, accentColor: Colors.cyan),
      CategoryEntity(id: '8', title: 'Healthy', icon: Icons.health_and_safety, accentColor: Colors.teal),
      CategoryEntity(id: '9', title: 'My Recipes', icon: Icons.person_pin, accentColor: Colors.purple),
    ];
  }

  @override
  Future<List<Recipe>> getRecipes({String? category}) async {
    return remoteDataSource.getRecipes(category: category);
  }

  @override
  Future<Recipe> getRecipe(int id) async {
    return remoteDataSource.getRecipe(id);
  }

  @override
  Future<void> addRecipe(RecipeEntity recipe) async {
    await remoteDataSource.addRecipe(
      title: recipe.title,
      ingredients: recipe.ingredientsString,
      instructions: recipe.instructions,
      imageUrl: recipe.imageUrl?.isNotEmpty == true ? recipe.imageUrl : null,
      category: recipe.category?.isNotEmpty == true ? recipe.category : null,
    );
    await localDataSource.addRecipe(recipe);
  }

  @override
  Future<Recipe> updateRecipe(int id, RecipeEntity recipe) async {
    return remoteDataSource.updateRecipe(
      id,
      title: recipe.title,
      ingredients: recipe.ingredientsString,
      instructions: recipe.instructions,
      imageUrl: recipe.imageUrl?.isNotEmpty == true ? recipe.imageUrl : null,
      category: recipe.category?.isNotEmpty == true ? recipe.category : null,
    );
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await remoteDataSource.deleteRecipe(id);
  }

  @override
  Future<List<Recipe>> getAIRecommendation(String prompt) async {
    return aiService.predict(prompt);
  }

  @override
  Future<List<Recipe>> searchByIngredients(String items) async {
    return remoteDataSource.searchByIngredients(items);
  }

  @override
  Future<List<Recipe>> searchByQuery(String query) async {
    return remoteDataSource.searchByQuery(query);
  }

  @override
  Future<bool> toggleFavorite(int recipeId) async {
    return remoteDataSource.toggleFavorite(recipeId);
  }

  @override
  Future<List<Recipe>> getFavorites() async {
    return remoteDataSource.getFavorites();
  }

  @override
  Future<bool> getFavoriteStatus(int recipeId) async {
    return remoteDataSource.getFavoriteStatus(recipeId);
  }
}
