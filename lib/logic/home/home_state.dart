part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitialState extends HomeState {}

final class HomeLoadingState extends HomeState {}

final class HomeAddCategorySuccessState extends HomeState {}
final class HomeDeleteCategorySuccessState extends HomeState {}

final class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}

final class HomeGetDataSuccessState extends HomeState {
  final List categories;

  HomeGetDataSuccessState({required this.categories});

}