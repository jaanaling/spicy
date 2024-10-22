part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class AddRecipe extends RecipeEvent {
  final RecipeModel recipe;
  final void Function() navigate;

  AddRecipe(this.recipe, this.navigate);

  @override
  List<Object> get props => [recipe, navigate];
}

class RemoveRecipe extends RecipeEvent {
  final String name;

  RemoveRecipe(this.name);

  @override
  List<Object> get props => [name];
}

class ToggleFavorite extends RecipeEvent {
  final String name;

  ToggleFavorite(this.name);

  @override
  List<Object> get props => [name];
}