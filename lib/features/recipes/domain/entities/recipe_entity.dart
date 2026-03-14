import 'package:equatable/equatable.dart';

/// Domain entity for creating a recipe (aligns with API RecipeBase).
/// Required: title, ingredients, instructions.
/// Optional: imageUrl, category.
class RecipeEntity extends Equatable {
  /// Id for new recipes (e.g. "0"); ignored when creating via API.
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  /// Optional image URL (API: image_url).
  final String? imageUrl;
  /// Optional category (API: category).
  final String? category;

  const RecipeEntity({
    this.id = '0',
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.category,
  });

  /// Ingredients as comma-separated string for API.
  String get ingredientsString => ingredients.join(', ');

  @override
  List<Object?> get props => [id, title, ingredients, instructions, imageUrl, category];
}
