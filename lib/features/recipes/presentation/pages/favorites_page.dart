import 'package:flutter/material.dart';
import '../../../../core/service_locator.dart' as di;
import 'recipe_details_page.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Recipe> _recipes = [];
  bool _loading = true;
  String? _error;

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = di.sl<RecipeRepository>();
      final list = await repo.getFavorites();
      if (mounted) {
        setState(() {
          _recipes = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Failed to load favorites';
          _loading = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(Recipe recipe) async {
    try {
      final repo = di.sl<RecipeRepository>();
      final isFav = await repo.toggleFavorite(recipe.id);
      if (!mounted) return;
      if (isFav) {
        setState(() {
          _recipes = _recipes.map((r) {
            if (r.id != recipe.id) return r;
            return Recipe(
              id: r.id,
              title: r.title,
              ingredients: r.ingredients,
              instructions: r.instructions,
              imageUrl: r.imageUrl,
              category: r.category,
              ownerId: r.ownerId,
              isFavorite: true,
            );
          }).toList();
        });
      } else {
        setState(() {
          _recipes = _recipes.where((r) => r.id != recipe.id).toList();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from favorites'),
            backgroundColor: Colors.orange.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final message = e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Could not update favorite';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7);
    const themeColor = Colors.red;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 8,
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.favorite_rounded, color: themeColor, size: 24),
            const SizedBox(width: 10),
            Text(
              'My Favorites',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: isDark ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: themeColor),
                  const SizedBox(height: 16),
                  Text(
                    'Loading favorites...',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade400),
                        const SizedBox(height: 16),
                        Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.red.shade700)),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _loadFavorites,
                          icon: const Icon(Icons.refresh_rounded, size: 20),
                          label: const Text('Retry'),
                          style: FilledButton.styleFrom(
                            backgroundColor: themeColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _recipes.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: themeColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.favorite_border_rounded, size: 64, color: themeColor),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No favorites yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the heart on any recipe to add it here',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadFavorites,
                      color: themeColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) => _buildRecipeCard(context, _recipes[index], themeColor, isDark),
                      ),
                    ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe, Color themeColor, bool isDark) {
    final imagePath = recipe.imageUrl;
    final useNetwork = imagePath != null && imagePath.isNotEmpty && imagePath.startsWith('http');

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
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
                    builder: (context) => RecipeDetailsPage(recipe: recipe, themeColor: themeColor),
                  ),
                ).then((_) => _loadFavorites()),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: useNetwork
                      ? Image.network(
                          imagePath,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage(isDark),
                        )
                      : _placeholderImage(isDark),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(recipe),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                    ),
                    child: Icon(Icons.favorite_rounded, color: themeColor, size: 22),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (recipe.category != null && recipe.category!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      recipe.category!,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: themeColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage(bool isDark) {
    return Container(
      height: 180,
      width: double.infinity,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      child: Icon(Icons.restaurant_rounded, size: 48, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
    );
  }
}
