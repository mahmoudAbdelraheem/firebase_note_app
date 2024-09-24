import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/data/models/note_model.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  NoteBloc() : super(NoteInitialState()) {
    on<NoteEvent>((event, emit) => emit(NoteLoadingState()));
    on<NoteAddNewNoteEvent>(_addNewNote);
    on<NoteGetAllNotesEvent>(_getAllNotes);
  }

  FutureOr<void> _addNewNote(
    NoteAddNewNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final CollectionReference noteCollection = _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc(event.categoryId)
          .collection('notes');

      await noteCollection.add({
        'title': event.title,
        'body': event.body,
        'color':
            '#${event.color.value.toRadixString(16).padLeft(8, '0')}', // Storing color as hex
        'date': DateTime.now(),
      });
      emit(NoteAddedSuccessState());
    } catch (e) {
      emit(NoteErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _getAllNotes(
    NoteGetAllNotesEvent event,
    Emitter<NoteState> emit,
  ) async {
    print(
        '=============================get all notes event is triggered=============================');
    try {
      final QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .collection('categories')
          .doc(event.categoryId)
          .collection('notes')
          .orderBy('date', descending: true)
          .get();

      List<NoteModel> notesData = [];

      notesData = querySnapshot.docs
          .map(
            (note) => NoteModel(
              id: note.id,
              body: note['body'],
              title: note['title'],
              color: _colorFromHex(
                note['color'],
              ), // Converting back to Color
            ),
          )
          .toList();
          
      emit(
        NoteGetAllNotesSuccessState(notes: notesData),
      );
    } catch (e) {
      emit(NoteErrorState(message: e.toString()));
    }
  }

  // Helper function to convert hex string to Color
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Ensure it's in ARGB format (with alpha).
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
