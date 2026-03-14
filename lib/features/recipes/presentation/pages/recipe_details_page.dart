import 'package:flutter/material.dart';
import '../../../../core/service_locator.dart' as di;
import '../../data/models/recipe_model.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeDetailsPage extends StatefulWidget {
  final Recipe recipe;
  final Color themeColor;

  const RecipeDetailsPage({
    super.key,
    required this.recipe,
    required this.themeColor,
  });

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final repo = di.sl<RecipeRepository>();
      final favorited = await repo.getFavoriteStatus(_recipe.id);
      if (mounted) {
        setState(() {
          _recipe = Recipe(
            id: _recipe.id,
            title: _recipe.title,
            ingredients: _recipe.ingredients,
            instructions: _recipe.instructions,
            imageUrl: _recipe.imageUrl,
            category: _recipe.category,
            ownerId: _recipe.ownerId,
            isFavorite: favorited,
          );
        });
      }
    } catch (_) {}
  }

  /// Parses instructions into a list of steps (newline or numbered patterns).
  List<String> _parseInstructionSteps(String instructions) {
    final trimmed = instructions.trim();
    if (trimmed.isEmpty) return [];

    // 1) Split by newlines and trim
    final lines = trimmed.split(RegExp(r'\r?\n')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.length > 1) {
      return lines.map((line) => _stripStepNumberPrefix(line)).where((s) => s.isNotEmpty).toList();
    }

    // 2) Single block: try to split by numbered pattern (1. 2. or 1) 2) or Step 1)
    final numbered = RegExp(r'\s*(?:Step\s+)?\d+[.)]\s*', caseSensitive: false);
    final parts = trimmed.split(numbered).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (parts.length > 1) return parts;

    // 3) Split by period only when it looks like sentence boundaries (space after)
    final byPeriod = trimmed.split(RegExp(r'\.\s+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (byPeriod.length > 1) return byPeriod;

    return [trimmed];
  }

  String _stripStepNumberPrefix(String line) {
    return line.replaceFirst(RegExp(r'^(?:Step\s+)?\d+[.)]\s*', caseSensitive: false), '').trim();
  }

  Future<void> _toggleFavorite() async {
    try {
      final repo = di.sl<RecipeRepository>();
      final isFav = await repo.toggleFavorite(_recipe.id);
      if (!mounted) return;
      setState(() {
        _recipe = Recipe(
          id: _recipe.id,
          title: _recipe.title,
          ingredients: _recipe.ingredients,
          instructions: _recipe.instructions,
          imageUrl: _recipe.imageUrl,
          category: _recipe.category,
          ownerId: _recipe.ownerId,
          isFavorite: isFav,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFav ? 'Added to favorites ❤️' : 'Removed from favorites'),
          backgroundColor: isFav ? Colors.red.shade400 : Colors.grey.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Could not update favorite'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7);
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? Colors.white70 : Colors.black54;

    final List<String> ingredientsList = _recipe.ingredients.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final List<String> instructionsList = _parseInstructionSteps(_recipe.instructions);

    final imageUrl = _recipe.imageUrl;
    final useNetwork = imageUrl != null && imageUrl.isNotEmpty && imageUrl.startsWith('http');
    final themeColor = widget.themeColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: surfaceColor,
            foregroundColor: textPrimary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _recipe.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: _recipe.isFavorite ? Colors.red : (isDark ? Colors.white70 : Colors.black54),
                  size: 26,
                ),
                onPressed: _toggleFavorite,
                tooltip: _recipe.isFavorite ? 'Remove from favorites' : 'Add to favorites',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  useNetwork
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(isDark),
                        )
                      : _placeholder(isDark),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scaffoldBg,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                      blurRadius: 20,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_recipe.category != null && _recipe.category!.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(isDark ? 0.25 : 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.category_rounded, size: 18, color: themeColor),
                              const SizedBox(width: 8),
                              Text(
                                _recipe.category!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: themeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        _recipe.title,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Ingredients section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(isDark ? 0.25 : 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.shopping_basket_rounded, size: 20, color: themeColor),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF252525) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ingredientsList.isEmpty
                            ? Text('No ingredients listed.', style: TextStyle(fontSize: 15, color: textSecondary))
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < ingredientsList.length; i++)
                                    Padding(
                                      padding: EdgeInsets.only(bottom: i < ingredientsList.length - 1 ? 14 : 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(top: 6),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: themeColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Expanded(
                                            child: Text(
                                              ingredientsList[i],
                                              style: TextStyle(
                                                fontSize: 16,
                                                height: 1.5,
                                                color: textPrimary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 28),
                      // Steps section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(isDark ? 0.25 : 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.format_list_numbered_rounded, size: 20, color: themeColor),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Steps',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF252525) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: instructionsList.isEmpty
                            ? Text(
                                _recipe.instructions.trim().isEmpty ? 'No steps listed.' : _recipe.instructions.trim(),
                                style: TextStyle(fontSize: 16, height: 1.5, color: textSecondary),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < instructionsList.length; i++) ...[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: themeColor,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: themeColor.withOpacity(0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            '${i + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 4),
                                            child: Text(
                                              instructionsList[i],
                                              style: TextStyle(
                                                fontSize: 16,
                                                height: 1.55,
                                                color: textPrimary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (i < instructionsList.length - 1) const SizedBox(height: 16),
                                  ],
                                ],
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
      child: Icon(Icons.restaurant_rounded, size: 80, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
    );
  }
}
