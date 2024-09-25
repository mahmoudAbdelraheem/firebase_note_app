import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/data/models/note_model.dart';

class NoteCardWidget extends StatelessWidget {
  final NoteModel note;
  final Function() onTap;
  final Function(DismissDirection value) onDelete;
  const NoteCardWidget({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        background: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        key: Key(note.id!),
        onDismissed: onDelete,
        child: FadeInRight(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              color: Color(note.color.value),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: note.imageUrl == null || note.imageUrl!.isEmpty
                      ? null
                      : Image.network(
                          note.imageUrl!,
                          width: 100,
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                  title: Text(
                    note.title,
                    style: const TextStyle(
                      height: 1.4,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    note.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(height: 1.4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
