import 'package:flutter/material.dart';
import '../../../recipes/data/models/recipe_model.dart';
class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("category"),
            Text(recipe.category, style: TextStyle(fontSize: 16)),
            Divider(height: 30),
            _sectionHeader("ingredients"),
            Text(recipe.ingredients, style: TextStyle(fontSize: 16)),
            Divider(height: 30),
            _sectionHeader("instructions"),
            Text(recipe.instructions, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange));
  }
}