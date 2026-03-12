import 'package:flutter/material.dart';
import '../../data/datasources/recipe_local_data_source.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../../auth/presentation/pages/recipe_details_page.dart';
import '../../../recipes/data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeListPage extends StatefulWidget {
  final String categoryName;
  final Color themeColor;

  const RecipeListPage({super.key, required this.categoryName, required this.themeColor});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  @override
  Widget build(BuildContext context) {
    final List<Recipe> filteredRecipes = RecipeRepository.allRecipes
        .where((r) => r.category.toLowerCase() == widget.categoryName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: Text(widget.categoryName,
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: widget.themeColor),
      ),
      body: filteredRecipes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = filteredRecipes[index];
          return _buildRecipeCard(context, recipe);
        },
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailsPage(recipe: recipe, themeColor: widget.themeColor),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  child: Image.asset(
                    recipe.imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      recipe.isFavorite = !recipe.isFavorite;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: recipe.isFavorite ? Colors.red : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _infoTag("${recipe.calories} kcal", Icons.local_fire_department_rounded),
                    const SizedBox(width: 15),
                    _infoTag("${recipe.time} mins", Icons.access_time_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTag(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: widget.themeColor),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 15),
          Text("No recipes here yet!", style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}