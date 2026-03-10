class Recipe {
  final int id;
  final String title;
  final String ingredients;
  final String instructions;
  final String category;
  final int calories;
  final int time;
  final String imagePath;
  bool isFavorite;
  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.calories,
    required this.time,
    required this.imagePath,
    this.isFavorite = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      ingredients: json['ingredients'] ?? '',
      instructions: json['instructions'] ?? '',
      category: json['category'] ?? '',
      calories: json['calories'] ?? 0,
      time: json['time'] ?? 0,
      imagePath: json['image_path'] ?? 'assets/images/placeholder.png',
    );
  }
}