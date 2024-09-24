import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_fire/data/models/note_model.dart';
import 'package:flutter_fire/logic/note/note_bloc.dart';

class AddUpdateNoteScreen extends StatefulWidget {
  final NoteModel note;
  final String categoryId;
  const AddUpdateNoteScreen(
      {super.key, required this.note, required this.categoryId});

  @override
  State<AddUpdateNoteScreen> createState() => _AddUpdateNoteScreenState();
}

class _AddUpdateNoteScreenState extends State<AddUpdateNoteScreen> {
  // Controllers for the title and note content
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Default background color for the note
  Color _noteColor = Colors.white;

  @override
  void initState() {
    _titleController.text = widget.note.title;
    _noteController.text = widget.note.body;
    _noteColor = widget.note.color;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Function to display color picker
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick Note Background Color'),
          content: BlockPicker(
            pickerColor: _noteColor,
            onColorChanged: (color) {
              setState(() {
                _noteColor = color;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            hintText: 'Note Title',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => _showColorPicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_titleController.text.isEmpty ||
                  _noteController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all the fields'),
                  ),
                );
                return;
              }
              BlocProvider.of<NoteBloc>(context).add(
                NoteAddNewNoteEvent(
                  categoryId: widget.categoryId,
                  title: _titleController.text,
                  body: _noteController.text,
                  color: _noteColor,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteAddedSuccessState) {
            BlocProvider.of<NoteBloc>(context).add(
              NoteGetAllNotesEvent(categoryId: widget.categoryId),
            );
          } else if (state is NoteGetAllNotesSuccessState) {
            Navigator.of(context).pop();
          } else if (state is NoteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          color: Color(_noteColor.value), // Use the selected background color
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _noteController,
            maxLines: null,
            minLines: 50, // Allow multi-line input
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              hintText: 'Type your note here...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
