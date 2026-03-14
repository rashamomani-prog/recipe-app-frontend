import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/service_locator.dart' as di;
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../data/models/recipe_model.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repositories/recipe_repository.dart';

class EditRecipePage extends StatefulWidget {
  final Recipe recipe;

  const EditRecipePage({super.key, required this.recipe});

  @override
  State<EditRecipePage> createState() => _EditRecipePageState();
}

class _EditRecipePageState extends State<EditRecipePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _imageUrlController;
  late List<TextEditingController> _ingredientControllers;
  late List<TextEditingController> _stepControllers;

  late String _selectedCategory;
  bool _saving = false;

  static List<String> _parseSteps(String instructions) {
    final trimmed = instructions.trim();
    if (trimmed.isEmpty) return [];
    final lines = trimmed.split(RegExp(r'\r?\n')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    if (lines.isNotEmpty) return lines;
    return [trimmed];
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.recipe.title);
    _imageUrlController = TextEditingController(text: widget.recipe.imageUrl ?? '');
    _selectedCategory = widget.recipe.category ?? 'Breakfast';
    final ingList = widget.recipe.ingredients.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    _ingredientControllers = ingList.isEmpty
        ? [TextEditingController()]
        : ingList.map((s) => TextEditingController(text: s)).toList();
    final stepList = _parseSteps(widget.recipe.instructions);
    _stepControllers = stepList.isEmpty
        ? [TextEditingController()]
        : stepList.map((s) => TextEditingController(text: s)).toList();
  }

  void _addIngredient() {
    setState(() => _ingredientControllers.add(TextEditingController()));
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length <= 1) return;
    _ingredientControllers[index].dispose();
    setState(() => _ingredientControllers.removeAt(index));
  }

  void _addStep() {
    setState(() => _stepControllers.add(TextEditingController()));
  }

  void _removeStep(int index) {
    if (_stepControllers.length <= 1) return;
    _stepControllers[index].dispose();
    setState(() => _stepControllers.removeAt(index));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    for (final c in _ingredientControllers) c.dispose();
    for (final c in _stepControllers) c.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ingredients = _ingredientControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    final steps = _stepControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    if (ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one ingredient'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    if (steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one step'), behavior: SnackBarBehavior.floating),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final entity = RecipeEntity(
        title: _titleController.text.trim(),
        ingredients: ingredients,
        instructions: steps.join('\n'),
        imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
        category: _selectedCategory,
      );
      await di.sl<RecipeRepository>().updateRecipe(widget.recipe.id, entity);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe updated!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is Exception ? e.toString().replaceFirst('Exception: ', '') : 'Failed to update'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static const List<String> _categories = [
    'Breakfast', 'Lunch', 'Dinner', 'Healthy', 'Desserts',
    'Drinks', 'Appetizers', 'Salads', 'Main Course',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F7);

    if (!context.read<AuthCubit>().isAdmin) {
      return Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: surfaceColor,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit Recipe', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: isDark ? Colors.white : Colors.black87)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.12), shape: BoxShape.circle),
                  child: Icon(Icons.admin_panel_settings_rounded, size: 56, color: Colors.orange.shade700),
                ),
                const SizedBox(height: 24),
                Text(
                  'Only admins can edit recipes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 12),
                Text(
                  'Please log in with an admin account to edit recipes.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded, size: 20),
                  label: const Text('Go back'),
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
        ),
      );
    }

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
            Icon(Icons.edit_rounded, color: Colors.orange.shade600, size: 24),
            const SizedBox(width: 10),
            Text(
              'Edit Recipe',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: isDark ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Basic info', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleController,
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter title' : null,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Recipe title',
                  hintText: 'e.g. Classic Pancakes',
                  prefixIcon: Icon(Icons.title_rounded, color: Colors.orange.shade600, size: 22),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade600, width: 2)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded, color: Colors.orange.shade600, size: 22),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade600, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _selectedCategory = v ?? 'Breakfast'),
              ),
              const SizedBox(height: 28),
              Text('Ingredients', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              const SizedBox(height: 12),
              ...List.generate(_ingredientControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ingredientControllers[index],
                          validator: (v) {
                            if (_ingredientControllers.length == 1 && (v?.trim().isEmpty ?? true)) return 'Add at least one ingredient';
                            return null;
                          },
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Ingredient ${index + 1}',
                            prefixIcon: Icon(Icons.circle, size: 8, color: Colors.orange.shade600),
                            filled: true,
                            fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade600, width: 2)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _ingredientControllers.length > 1 ? () => _removeIngredient(index) : null,
                        icon: Icon(Icons.remove_circle_outline, color: _ingredientControllers.length > 1 ? Colors.grey : Colors.grey.shade300),
                        tooltip: 'Remove',
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed: _addIngredient,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add ingredient'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 24),
              Text('Steps', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              const SizedBox(height: 12),
              ...List.generate(_stepControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('${index + 1}', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.orange.shade800)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _stepControllers[index],
                          maxLines: 2,
                          validator: (v) {
                            if (_stepControllers.length == 1 && (v?.trim().isEmpty ?? true)) return 'Add at least one step';
                            return null;
                          },
                          style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Step ${index + 1}',
                            filled: true,
                            fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade600, width: 2)),
                            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Colors.red)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _stepControllers.length > 1 ? () => _removeStep(index) : null,
                        icon: Icon(Icons.remove_circle_outline, color: _stepControllers.length > 1 ? Colors.grey : Colors.grey.shade300),
                        tooltip: 'Remove step',
                      ),
                    ],
                  ),
                );
              }),
              OutlinedButton.icon(
                onPressed: _addStep,
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add step'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange.shade700,
                  side: BorderSide(color: Colors.orange.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 28),
              Text('Media (optional)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[600])),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: Icon(Icons.image_rounded, color: Colors.orange.shade600, size: 22),
                  filled: true,
                  fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade50,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey.shade300)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.orange.shade600, width: 2)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
              const SizedBox(height: 36),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_rounded, size: 22),
                label: Text(
                  _saving ? 'Saving...' : 'Save changes',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
