part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class NoteAddOrUpdateNoteEvent extends NoteEvent {
  final String categoryId;
  final String id;
  final String title;
  final String body;
  final Color color;
  final String imageUrl;
  NoteAddOrUpdateNoteEvent({
    this.id = '',
    required this.categoryId,
    required this.title,
    required this.body,
    required this.color,
    required this.imageUrl,
  });
}

class NoteDeleteNoteEvent extends NoteEvent {
  final String noteId;
  final String categoryId;
  final String imageUrl;
  NoteDeleteNoteEvent({
    required this.noteId,
    required this.categoryId,
    required this.imageUrl,
  });
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

class NoteListenToNotesStreamEvent extends NoteEvent {
  final String categoryId;

  NoteListenToNotesStreamEvent({required this.categoryId});
}
