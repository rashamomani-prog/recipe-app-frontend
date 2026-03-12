import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../recipes/domain/entities/category_entity.dart';
import '../../../recipes/presentation/cubit/recipe_cubit.dart';
import '../../../recipes/presentation/cubit/recipe_state.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      appBar: AppBar(
        title: const Text(
            "Rashify Pro 👩‍🍳",
            style: TextStyle(color: Color(0xFF2D2D2D), fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.orange),
            onPressed: () => context.read<RecipeCubit>().fetchRecipes(),
          ),
        ],
      ),
      body: BlocBuilder<RecipeCubit, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (state is RecipeError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is RecipeLoaded) {
            final items = state.result;

            if (items.isEmpty) {
              return const Center(child: Text("No categories found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final category = items[index] as CategoryEntity;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: category.accentColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(category.icon, color: Colors.orange.shade400, size: 28),
                    ),
                    title: Text(
                        category.title,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A))
                    ),
                    subtitle: const Text("Tap to see recipes", style: TextStyle(fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    onTap: () {
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("The kitchen is being prepared..."));
        },
      ),
    );
  }
}