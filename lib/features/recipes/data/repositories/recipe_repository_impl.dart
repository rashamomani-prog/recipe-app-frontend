import 'package:rashify_app/features/recipes/data/datasources/recipe_remote_data_source.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import 'package:flutter/material.dart';
import '../../data/models/recipe_model.dart';
class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeLocalDataSource localDataSource;

  RecipeRepositoryImpl({required this.localDataSource, required RecipeRemoteDataSource remoteDataSource});

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
  Future<void> addRecipe(RecipeEntity recipe) async {
    await localDataSource.addRecipe(recipe);
  }
  @override
  Future<String> getAIRecommendation(String query) async {
    return "AI recommendation for $query";
  }
}