import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'add_recipe_page.dart';
import 'recipe_list_page.dart';

class CategoriesEntity {
  final String title;
  final IconData icon;
  final Color accentColor;

  CategoriesEntity({required this.title, required this.icon, required this.accentColor});
}

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});
  final List<CategoriesEntity> allCategories = [
    CategoriesEntity(title: 'Breakfast', icon: Icons.coffee_outlined, accentColor: const Color(0xFFFFFBEE)),
    CategoriesEntity(title: 'Lunch', icon: Icons.restaurant_outlined, accentColor: const Color(0xFFFFEFFE)),
    CategoriesEntity(title: 'Dinner', icon: Icons.nightlight_outlined, accentColor: const Color(0xFFF0F9FF)),
    CategoriesEntity(title: 'Salads', icon: Icons.flatware_outlined, accentColor: const Color(0xFFE8F5E9)),
    CategoriesEntity(title: 'Appetizers', icon: Icons.tapas_outlined, accentColor: const Color(0xFFEFEBE9)),
    CategoriesEntity(title: 'Desserts', icon: Icons.cake_outlined, accentColor: const Color(0xFFF2FCE2)),
    CategoriesEntity(title: 'Drinks', icon: Icons.local_drink_outlined, accentColor: const Color(0xFFFFF3E0)),
    CategoriesEntity(title: 'Healthy', icon: Icons.spa_outlined, accentColor: const Color(0xFFE0F2F1)),
    CategoriesEntity(title: 'My Recipes', icon: Icons.person_pin_outlined, accentColor: const Color(0xFFF3E5F5)),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthSuccess ? authState.user : null;
        final isAdmin = user?.role?.toLowerCase() == 'admin';

        return Scaffold(
          backgroundColor: const Color(0xFFFAF9F6),
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("All Categories", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                if (user != null)
                  Text(
                    '${user.name}${isAdmin ? ' · Admin' : ' · User'}',
                    style: TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.normal),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: GridView.builder(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.85,
        ),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeListPage(
                    categoryName: category.title,
                    themeColor: _getIconColor(category.title),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: _buildCategoryCard(category),
          );
        },
      ),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddRecipePage()),
                    );
                  },
                  icon: const Icon(Icons.add_circle_outline, size: 26),
                  label: const Text('Add Recipe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  elevation: 6,
                )
              : null,
        );
      },
    );
  }

  Widget _buildCategoryCard(CategoriesEntity category) {
    Color iconColor = _getIconColor(category.title);

    return Container(
      decoration: BoxDecoration(
        color: category.accentColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: iconColor.withOpacity(0.1), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(category.icon, color: iconColor, size: 35),
          ),
          const SizedBox(height: 15),
          Text(
            category.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Color _getIconColor(String title) {
    switch (title) {
      case 'Breakfast': return Colors.orange;
      case 'Lunch': return Colors.pink;
      case 'Dinner': return Colors.blue;
      case 'Salads': return Colors.green;
      case 'Appetizers': return Colors.brown;
      case 'Desserts': return Colors.green;
      case 'Drinks': return Colors.brown;
      case 'Healthy': return Colors.teal;
      case 'My Recipes': return Colors.purple;
      default: return Colors.orange;
    }
  }
}