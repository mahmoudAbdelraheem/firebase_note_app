part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

final class HomeAddCategoryEvent extends HomeEvent {
  final String category;

  const HomeAddCategoryEvent({required this.category});
}

final class HomeGetDataEvent extends HomeEvent {}

final class HomeDeleteCategoryEvent extends HomeEvent {
  final String categoryId;
  const HomeDeleteCategoryEvent({required this.categoryId});
}
