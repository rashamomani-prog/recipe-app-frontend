import '../../domain/entities/category_entity.dart';

abstract class RecipeState {}

class RecipeInitial extends RecipeState {}
class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<dynamic> result;

  RecipeLoaded(this.result);
}

class RecipeError extends RecipeState {
  final String message;
  RecipeError(this.message);
}
// أضيفي هاد الكلاس تحت الـ RecipeState
class RecipeAISuccess extends RecipeState {
  final String recommendation;
  RecipeAISuccess(this.recommendation);

  @override
  List<Object> get props => [recommendation];
}