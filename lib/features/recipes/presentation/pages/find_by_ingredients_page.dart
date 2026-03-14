import 'package:flutter/material.dart';
import '../../../../core/service_locator.dart' as di;
import 'recipe_details_page.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../../../../services/ai_service.dart';

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
  String? _error;

  Future<void> _searchRecipes() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      _loading = true;
      _results = [];
      _error = null;
    });

    try {
      final repo = di.sl<RecipeRepository>();
      List<Recipe> list;
      if (input.contains(',') || !input.contains(' ')) {
        list = await repo.searchByIngredients(input);
      } else {
        list = await repo.searchByQuery(input);
      }
      if (list.isEmpty) {
        final aiList = await AIService.findRecipesByIngredients(input);
        list = aiList;
      }
      setState(() {
        _results = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
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
                labelText: 'Enter ingredients separated by comma, or a search query',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onSubmitted: (_) => _searchRecipes(),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _loading ? null : _searchRecipes,
              style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor),
              child: const Text('Search Recipes'),
            ),
            const SizedBox(height: 20),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            if (_loading) const Expanded(child: Center(child: CircularProgressIndicator())),
            if (!_loading)
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final recipe = _results[index];
                    final useNetwork = recipe.imageUrl != null &&
                        recipe.imageUrl!.isNotEmpty &&
                        recipe.imageUrl!.startsWith('http');
                    return ListTile(
                      leading: useNetwork
                          ? Image.network(
                              recipe.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _placeholder(50),
                            )
                          : _placeholder(50),
                      title: Text(recipe.title),
                      subtitle: recipe.category != null ? Text(recipe.category!) : null,
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

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      color: Colors.grey[300],
      child: Icon(Icons.restaurant, color: Colors.grey[500]),
    );
  }
}
