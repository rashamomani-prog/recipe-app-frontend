import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service_locator.dart' as di;
import '../../domain/repositories/recipe_repository.dart';
import '../cubit/recipe_cubit.dart';
import '../cubit/recipe_state.dart';
import 'categories_page.dart';
import 'recipe_list_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final recipeRepo = di.sl<RecipeRepository>();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: Text(
            "Rashify 🥗",
            style: TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: isDark ? Colors.white : Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back,",
                style: TextStyle(fontSize: 16, color: isDark ? Colors.white70 : Colors.grey),
              ),
              Text(
                "What to cook today? 👨‍🍳",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 25),

              // --- شريط البحث الذكي ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  onSubmitted: (value) {
                    // مننادي الـ askAI الموجودة في الـ Cubit
                    context.read<RecipeCubit>().askAI(value);
                    _showAISuggestions(context, value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search or ask AI Chef...",
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
                    border: InputBorder.none,
                    icon: const Icon(Icons.search, color: Colors.orange),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFAB40), Color(0xFFFF9100)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Featured Recipe", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    SizedBox(height: 5),
                    Text("Healthy Quinoa Salad",
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Explore Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                    },
                    child: const Text("View All", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  )
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildQuickCategory(context, Icons.spa_outlined, "Healthy",
                        isDark ? Colors.green.withOpacity(0.2) : const Color(0xFFE2F3E9), Colors.green),
                    _buildQuickCategory(context, Icons.cake_outlined, "Desserts",
                        isDark ? Colors.pink.withOpacity(0.2) : const Color(0xFFFCE4EC), Colors.pink),
                    _buildQuickCategory(context, Icons.coffee_outlined, "Breakfast",
                        isDark ? Colors.orange.withOpacity(0.2) : const Color(0xFFFFF3E0), Colors.orange),
                    _buildQuickCategory(context, Icons.local_drink_outlined, "Drinks",
                        isDark ? Colors.blue.withOpacity(0.2) : const Color(0xFFE1F5FE), Colors.blue),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "AI Chef Suggestions ✨",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black
                ),
              ),
              const SizedBox(height: 10),

              // --- تعديل قسم الاقتراحات ليعمل بالـ BlocBuilder ---
              BlocBuilder<RecipeCubit, RecipeState>(
                builder: (context, state) {
                  String aiMessage = "Ask me to suggest a recipe from your 103 options!";
                  bool isLoading = false;

                  if (state is RecipeLoading) {
                    isLoading = true;
                  } else if (state is RecipeAISuccess) {
                    aiMessage = state.recommendation;
                  } else if (state is RecipeError) {
                    aiMessage = "Chef is a bit busy, but try the Quinoa Salad!";
                  }

                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        isLoading
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange))
                            : const Icon(Icons.auto_awesome, color: Colors.orange),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Text(
                            aiMessage,
                            style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: isDark ? Colors.white70 : Colors.black87
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAISuggestions(BuildContext context, String query) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            // ملاحظة: الـ BottomSheet هون بضل يستخدم FutureBuilder إذا بدك نتيجة سريعة منفصلة
            return FutureBuilder<String>(
              future: recipeRepo.getAIRecommendation(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.orange));
                }
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const Text("AI Recommendation ✨",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      Text(snapshot.data ?? "No result found."),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickCategory(BuildContext context, IconData icon, String label, Color bgColor, Color iconColor) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeListPage(
                categoryName: label,
                themeColor: iconColor,
              ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 13
              ),
            ),
          ],
        ),
      ),
    );
  }
}