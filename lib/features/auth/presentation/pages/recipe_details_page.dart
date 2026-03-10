import 'package:flutter/material.dart';
import '../../../recipes/data/models/recipe_model.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;
  final Color themeColor;

  const RecipeDetailsPage({
    super.key,
    required this.recipe,
    required this.themeColor
  });

  @override
  Widget build(BuildContext context) {
    // تحويل البيانات لضمان التعامل معها كقائمة
    final List<String> ingredientsList = recipe.ingredients.split(',');
    final List<String> instructionsList = recipe.instructions.split('.');

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            stretch: true,
            backgroundColor: themeColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                recipe.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[200], child: Icon(Icons.fastfood, size: 50, color: themeColor)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان
                  Text(recipe.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // شريط المعلومات
                  Row(
                    children: [
                      _infoChip("${recipe.calories} kcal", Icons.local_fire_department, Colors.orange),
                      const SizedBox(width: 10),
                      _infoChip("${recipe.time} mins", Icons.timer_outlined, themeColor),
                    ],
                  ),

                  const Divider(height: 40, thickness: 1),

                  // المكونات
                  const Text("Ingredients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  for (var item in ingredientsList)
                    if (item.trim().isNotEmpty) _buildIngredientRow(item.trim()),

                  const SizedBox(height: 35),

                  // الخطوات
                  const Text("Preparation Steps", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  for (int i = 0; i < instructionsList.length; i++)
                    if (instructionsList[i].trim().isNotEmpty)
                      _buildStepRow(i + 1, instructionsList[i].trim()),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, size: 18, color: themeColor),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _buildStepRow(int stepNumber, String stepText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: themeColor,
            child: Text("$stepNumber", style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              stepText,
              style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}