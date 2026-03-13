import 'package:flutter/material.dart';
import '../../../../services/ai_service.dart';
import '../../../auth/presentation/pages/recipe_details_page.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../../recipes/data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../../auth/presentation/pages/recipe_details_page.dart';
class FindByIngredientsPage extends StatefulWidget {
  final Color themeColor;
  const FindByIngredientsPage({super.key, required this.themeColor});

  @override
  State<FindByIngredientsPage> createState() => _FindByIngredientsPageState();
}

class _FindByIngredientsPageState extends State<FindByIngredientsPage> {
  final TextEditingController _controller = TextEditingController();
  List<Recipe> _results = [];
  bool _loading = false;

  void _searchRecipes() async {
    final input = _controller.text.toLowerCase().trim();
    if (input.isEmpty) return;

    setState(() {
      _loading = true;
      _results = [];
    });

    // البحث المحلي أولاً
    final localMatches = RecipeRepository.allRecipes.where((r) {
      return input.split(',').every(
              (ingredient) => r.ingredients.toLowerCase().contains(ingredient.trim()));
    }).toList();

    // لو ما في نتائج، نستخدم AI
    if (localMatches.isEmpty) {
      // هنا تستدعي AIService مع المكونات
      final aiResults = await AIService.findRecipesByIngredients(input); // ترجع List<Recipe>
      setState(() {
        _results = aiResults;
        _loading = false;
      });
    } else {
      setState(() {
        _results = localMatches;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Recipe by Ingredients'),
        backgroundColor: widget.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter ingredients separated by comma',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _searchRecipes,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.themeColor,
              ),
              child: const Text('Search Recipes'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (!_loading)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final recipe = _results[index];
                    return ListTile(
                      leading: Image.asset(recipe.imagePath, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(recipe.title),
                      subtitle: Text('${recipe.calories} kcal | ${recipe.time} mins'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailsPage(recipe: recipe, themeColor: widget.themeColor),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}