import 'package:equatable/equatable.dart';

class RecipeEntity extends Equatable {
  final String id;
  final String title;
  final String category;
  final String imagePath;
  final String time;
  final List<String> ingredients;
  final String instructions;
  final int calories;

  const RecipeEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.imagePath,
    required this.time,
    required this.ingredients,
    required this.instructions,
    required this.calories,
  });

  @override
  List<Object?> get props => [id, title, category, time,calories];
}