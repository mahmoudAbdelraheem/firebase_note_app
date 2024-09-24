part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class NoteAddNewNoteEvent extends NoteEvent {
  final String categoryId;
  final String title;
  final String body;
  final Color color;
  NoteAddNewNoteEvent({
    required this.categoryId,
    required this.title,
    required this.body,
    required this.color,
  });
}

class NoteDeleteNoteEvent extends NoteEvent {
  final String noteId;
  NoteDeleteNoteEvent({required this.noteId});
}

class NoteUpdateNoteEvent extends NoteEvent {
  final String noteId;
  final String title;
  final String body;
  final Color color;
  NoteUpdateNoteEvent({
    required this.noteId,
    required this.title,
    required this.body,
    required this.color,
  });
}

class NoteGetAllNotesEvent extends NoteEvent {
  final String categoryId;
  NoteGetAllNotesEvent({required this.categoryId});
}