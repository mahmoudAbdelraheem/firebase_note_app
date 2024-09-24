import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/data/models/note_model.dart';
import 'package:flutter_fire/repositories/notes/notes_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository;
   StreamSubscription<List<NoteModel>>? _noteStreamSubscription;

  NoteBloc({required this.noteRepository}) : super(NoteInitialState()) {
    on<NoteEvent>((event, emit) => emit(NoteLoadingState()));
    on<NoteAddOrUpdateNoteEvent>(_addOrUpdateNote);
    on<NoteGetAllNotesEvent>(_getAllNotes);
    on<NoteDeleteNoteEvent>(_deleteNote);
    on<NoteListenToNotesStreamEvent>(_listenToNotesStream);
  }

  FutureOr<void> _deleteNote(
    NoteDeleteNoteEvent event,
    Emitter<NoteState> emit,
  )async {
    try {
      await noteRepository.deleteNote(event.categoryId, event.noteId);
      emit(NoteDeletedSuccessState());
      // add(NoteGetAllNotesEvent(categoryId: event.categoryId));
    } catch (e) {
      emit(NoteErrorState(message: e.toString()));
    }
  }
  FutureOr<void> _addOrUpdateNote(
    NoteAddOrUpdateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      final note = NoteModel(
        id: event.id,
        title: event.title,
        body: event.body,
        color: event.color,
      );
      await noteRepository.addOrUpdateNote(event.categoryId, note);

      emit(NoteAddedOrUpdatedSuccessState());
    } catch (e) {
      emit(NoteErrorState(message: e.toString()));
    }
  }

   FutureOr<void> _listenToNotesStream(
      NoteListenToNotesStreamEvent event, Emitter<NoteState> emit,) async{
     // Cancel any existing subscription before starting a new one
    await _noteStreamSubscription?.cancel();

    _noteStreamSubscription =
        noteRepository.getNotesStream(event.categoryId).listen((notes) {
      if (!emit.isDone) {
        emit(NoteGetAllNotesSuccessState(notes: notes));
      }
    }, onError: (error) {
      if (!emit.isDone) {
        emit(NoteErrorState(message: error.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _noteStreamSubscription?.cancel();
    return super.close();
  }



  FutureOr<void> _getAllNotes(
    NoteGetAllNotesEvent event,
    Emitter<NoteState> emit,
  ) async {

     try {
      final notes = await noteRepository.getAllNotes(event.categoryId);
      emit(NoteGetAllNotesSuccessState(notes: notes));
    } catch (e) {
      emit(NoteErrorState(message: e.toString()));
    }
  }

}
