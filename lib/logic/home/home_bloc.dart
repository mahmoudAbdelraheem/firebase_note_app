import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeEvent>((event, emit) => emit(HomeLoadingState()));
    on<HomeAddCategoryEvent>(_addNewCategory);
    on<HomeGetDataEvent>(_getData);
    on<HomeDeleteCategoryEvent>(_deleteCategory);
  }

  FutureOr<void> _addNewCategory(
      HomeAddCategoryEvent event, Emitter<HomeState> emit) async {
    try {
      final User currentUser = FirebaseAuth.instance.currentUser!;
      final CollectionReference categoryCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('categories');
      await categoryCollection.add({"name": event.category});
      emit(HomeAddCategorySuccessState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _getData(
    HomeGetDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final User currentUser = FirebaseAuth.instance.currentUser!;

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('categories')
          .get();
      emit(
        HomeGetDataSuccessState(categories: querySnapshot.docs),
      );
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _deleteCategory(
    HomeDeleteCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('categories')
          .doc(event.categoryId)
          .delete();
      emit(HomeDeleteCategorySuccessState());
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }
}
