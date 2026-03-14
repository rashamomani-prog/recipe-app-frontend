/// Recipe model aligned with Rashify API.
/// List/search: id, title, ingredients, instructions, image_url, category, owner_id.
/// RecipeOut (create response): id, owner_id (int?), title, ingredients, instructions, image_url, category.
class Recipe {
  final int id;
  final String title;
  final String ingredients;
  final String instructions;
  final String? imageUrl;
  final String? category;
  final int ownerId;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.imageUrl,
    this.category,
    required this.ownerId,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ownerIdRaw = json['owner_id'];
    final ownerId = ownerIdRaw is int
        ? ownerIdRaw
        : (ownerIdRaw is num ? ownerIdRaw.toInt() : 0);
    return Recipe(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      ingredients: json['ingredients'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String?,
      ownerId: ownerId,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'image_url': imageUrl,
      'category': category,
      'owner_id': ownerId,
    };
  }

  /// For RecipeBase (create body): title, ingredients, instructions, image_url?, category?
  Map<String, dynamic> toCreateJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'image_url': imageUrl,
      'category': category,
    };
  }

  /// Local display: use imageUrl if present, else placeholder path.
  String get imagePath => imageUrl ?? '';
}
