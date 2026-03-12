import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recipe_cubit.dart';
import '../../domain/entities/recipe_entity.dart';

class AddRecipePage extends StatefulWidget {
  const AddRecipePage({super.key});

  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  String _selectedCategory = 'Breakfast';

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add My Recipe 👩‍🍳'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Recipe Title', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                items: [
                  'Breakfast',
                  'Lunch',
                  'Dinner',
                  'Healthy',
                  'Desserts',
                  'Drinks',
                  'Appetizers',
                  'Salads',
                  'My Recipes'
                ]
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategory = val!),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(labelText: 'Ingredients', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter ingredients' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions', border: OutlineInputBorder()),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Enter preparation steps' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(labelText: 'Calories', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter calories' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.orangeAccent,
                ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newRecipe = RecipeEntity(
                        id: 0.toString(),
                        title: _titleController.text,
                        category: _selectedCategory,

                        ingredients: _ingredientsController.text.split(','),

                        instructions: _instructionsController.text,
                        calories: int.tryParse(_caloriesController.text) ?? 0,

                        time: 30.toString(),

                        imagePath: 'assets/images/default_recipe.jpg',
                      );

                      context.read<RecipeCubit>().addRecipe(newRecipe);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully added to your recipes! 🎉')),
                      );
                    }
                },
                child: const Text('Save to My Database', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}