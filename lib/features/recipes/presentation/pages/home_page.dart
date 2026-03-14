import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service_locator.dart' as di;
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'recipe_details_page.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';
import 'add_recipe_page.dart';
import 'categories_page.dart';
import 'edit_recipe_page.dart';
import 'favorites_page.dart';
import 'find_by_ingredients_page.dart';
import 'recipe_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Category item for home (title, icon, color). Order matches CategoriesPage.
class _CategoryItem {
  final String title;
  final IconData icon;
  final Color color;
  const _CategoryItem(this.title, this.icon, this.color);
}

class _HomePageState extends State<HomePage> {
  static final List<_CategoryItem> _categories = [
    _CategoryItem('Breakfast', Icons.coffee_outlined, Colors.orange),
    _CategoryItem('Lunch', Icons.restaurant_outlined, Colors.deepOrange),
    _CategoryItem('Dinner', Icons.nightlight_outlined, Colors.blue),
    _CategoryItem('Salads', Icons.flatware_outlined, Colors.green),
    _CategoryItem('Appetizers', Icons.tapas_outlined, Colors.brown),
    _CategoryItem('Desserts', Icons.cake_outlined, Colors.pink),
    _CategoryItem('Drinks', Icons.local_drink_outlined, Colors.cyan),
    _CategoryItem('Healthy', Icons.spa_outlined, Colors.teal),
    _CategoryItem('My Recipes', Icons.person_pin_outlined, Colors.purple),
  ];

  List<Recipe> _allRecipes = [];
  bool _loading = true;
  String? _error;

  /// Recipes grouped by category (category title -> list of recipes).
  Map<String, List<Recipe>> get _recipesByCategory {
    final map = <String, List<Recipe>>{};
    for (final recipe in _allRecipes) {
      final key = (recipe.category?.trim().isNotEmpty == true)
          ? recipe.category!
          : 'Other';
      map.putIfAbsent(key, () => []).add(recipe);
    }
    return map;
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = di.sl<RecipeRepository>();
      final list = await repo.getRecipes();
      if (mounted) {
        setState(() {
          _allRecipes = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _loading = false;
        });
      }
    }
  }

  void _updateRecipeInLists(int recipeId, Recipe updated) {
    setState(() {
      _allRecipes = _allRecipes.map((r) => r.id == recipeId ? updated : r).toList();
    });
  }

  void _removeRecipeFromLists(int recipeId) {
    setState(() {
      _allRecipes = _allRecipes.where((r) => r.id != recipeId).toList();
    });
  }

  Future<void> _deleteRecipe(Recipe recipe, bool isAdmin) async {
    if (!isAdmin) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text('Delete "${recipe.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    try {
      final repo = di.sl<RecipeRepository>();
      await repo.deleteRecipe(recipe.id);
      if (!mounted) return;
      _removeRecipeFromLists(recipe.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe deleted'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Failed to delete'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthSuccess ? authState.user : null;
        final isAdmin = user?.role?.toLowerCase() == 'admin';

        final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7);

        return Scaffold(
          backgroundColor: scaffoldBg,
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 8,
            backgroundColor: surfaceColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.grid_view_rounded, color: isDark ? Colors.white : Colors.black87),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesPage())),
            ),
            title: Row(
              children: [
                Text(
                  'Rashify',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                if (user != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAdmin ? Colors.orange.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isAdmin ? Colors.orange.shade800 : Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border_rounded, size: 22, color: isDark ? Colors.white70 : Colors.black54),
                tooltip: 'My Favorites',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesPage()),
                ),
              ),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? Colors.white12 : Colors.black.withOpacity(0.06),
                  foregroundColor: isDark ? Colors.white : Colors.black87,
                ),
                icon: const Icon(Icons.search_rounded, size: 22),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FindByIngredientsPage(themeColor: Colors.orange)),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.logout_rounded, size: 22, color: isDark ? Colors.white70 : Colors.black54),
                onPressed: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Logout')),
                      ],
                    ),
                  );
                  if (ok == true && context.mounted) {
                    context.read<AuthCubit>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (_) => false,
                    );
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _loadRecipes,
            child: _loading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            color: Colors.orange.shade600,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading recipes...',
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.error_outline_rounded, size: 48, color: Colors.red.shade700),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15, color: Colors.red.shade700, height: 1.4),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: _loadRecipes,
                                icon: const Icon(Icons.refresh_rounded, size: 20),
                                label: const Text('Retry'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _allRecipes.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(28),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.restaurant_menu_rounded, size: 64, color: Colors.orange.shade700),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'No recipes yet',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Browse categories or add your first recipe',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                                  ),
                                  if (isAdmin) ...[
                                    const SizedBox(height: 28),
                                    FilledButton.icon(
                                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecipePage())).then((_) => _loadRecipes()),
                                      icon: const Icon(Icons.add_circle_outline_rounded, size: 22),
                                      label: const Text('Add first recipe'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                        elevation: 2,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : CustomScrollView(
                            slivers: [
                              // Welcome strip
                              if (user != null)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                    child: Text(
                                      'Hi, ${user.name}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white : Colors.black87,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              // 1. Categories section
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.category_rounded, size: 20, color: Colors.orange.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Categories',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : Colors.black87,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SliverToBoxAdapter(
                                child: SizedBox(
                                  height: 108,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    itemCount: _categories.length,
                                    itemBuilder: (context, index) {
                                      final cat = _categories[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 12),
                                        child: _buildCategoryChip(context, cat, isDark),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SliverToBoxAdapter(child: SizedBox(height: 24)),
                              // 2. Recipes by category
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.restaurant_menu_rounded, size: 20, color: Colors.orange.shade700),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Recipes by category',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : Colors.black87,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ..._categories.map((cat) {
                                final recipes = _recipesByCategory[cat.title] ?? [];
                                if (recipes.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                                return SliverPadding(
                                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                  sliver: SliverToBoxAdapter(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: cat.color.withOpacity(isDark ? 0.25 : 0.15),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Icon(cat.icon, color: cat.color, size: 22),
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              cat.title,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                            const Spacer(),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: cat.color,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              ),
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => RecipeListPage(
                                                    categoryName: cat.title,
                                                    themeColor: cat.color,
                                                  ),
                                                ),
                                              ),
                                              child: const Text('See all →'),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        ...recipes.map((recipe) => Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: _buildRecipeCard(context, recipe, isAdmin, isDark),
                                        )),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                              // Other (recipes with unknown category)
                              if ((_recipesByCategory['Other'] ?? []).isNotEmpty) ...[
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                                    child: Text(
                                      'Other',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverPadding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final recipe = _recipesByCategory['Other']![index];
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: _buildRecipeCard(context, recipe, isAdmin, isDark),
                                        );
                                      },
                                      childCount: _recipesByCategory['Other']!.length,
                                    ),
                                  ),
                                ),
                              ],
                              const SliverToBoxAdapter(child: SizedBox(height: 24)),
                            ],
                          ),
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecipePage()));
                    _loadRecipes();
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 26),
                  label: const Text('Add Recipe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  focusElevation: 8,
                  hoverElevation: 10,
                )
              : null,
        );
      },
    );
  }

  Widget _buildCategoryChip(BuildContext context, _CategoryItem cat, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeListPage(
              categoryName: cat.title,
              themeColor: cat.color,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 92,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? cat.color.withOpacity(0.18) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cat.color.withOpacity(isDark ? 0.4 : 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(cat.icon, color: cat.color, size: 30),
              const SizedBox(height: 8),
              Text(
                cat.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe, bool isAdmin, bool isDark) {
    final themeColor = Colors.orange;
    final String? imageUrl = recipe.imageUrl;
    final bool useNetwork = imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http');
    final cardBg = isDark ? const Color(0xFF252525) : Colors.white;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailsPage(recipe: recipe, themeColor: themeColor),
                    ),
                  ),
                  child: useNetwork
                      ? Image.network(imageUrl!, height: 190, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _placeholder(190, isDark))
                      : _placeholder(190, isDark),
                ),
                // Gradient overlay at bottom of image
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAdmin) ...[
                        _actionChip(
                          icon: Icons.edit_rounded,
                          color: Colors.white,
                          iconColor: Colors.blue.shade700,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditRecipePage(recipe: recipe)),
                            );
                            _loadRecipes();
                          },
                        ),
                        const SizedBox(width: 8),
                        _actionChip(
                          icon: Icons.delete_rounded,
                          color: Colors.white,
                          iconColor: Colors.red.shade700,
                          onTap: () => _deleteRecipe(recipe, isAdmin),
                        ),
                      ],
                    ],
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
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (recipe.category != null && recipe.category!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          recipe.category!,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: themeColor.shade700),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required Color color,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      elevation: 2,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: iconColor ?? Colors.grey.shade700, size: 22),
        ),
      ),
    );
  }

  Widget _placeholder(double height, bool isDark) {
    return Container(
      height: height,
      width: double.infinity,
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      child: Icon(Icons.restaurant_rounded, size: 48, color: isDark ? Colors.grey.shade600 : Colors.grey.shade500),
    );
  }
}
