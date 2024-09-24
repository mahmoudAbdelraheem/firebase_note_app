part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitialState extends NoteState {}
final class NoteLoadingState extends NoteState {}
final class NoteAddedSuccessState extends NoteState {}

final class NoteErrorState extends NoteState {
  final String message;
  NoteErrorState({required this.message});
}

final class NoteGetAllNotesSuccessState extends NoteState {
  final List<NoteModel> notes;
  NoteGetAllNotesSuccessState({required this.notes});
}