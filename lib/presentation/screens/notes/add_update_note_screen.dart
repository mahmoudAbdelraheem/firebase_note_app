import 'dart:io';
import 'package:flutter_fire/core/widgets/loader.dart';
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_fire/data/models/note_model.dart';
import 'package:flutter_fire/logic/note/note_bloc.dart';
import 'package:flutter_fire/presentation/widgets/notes/camera_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';

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
  String imageUrl = '';
  bool isImageLoading = false;
  @override
  void initState() {
    _titleController.text = widget.note.title;
    _noteController.text = widget.note.body;
    _noteColor = widget.note.color;
    imageUrl = widget.note.imageUrl ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Function to get image
  void _getAndUploadImage(ImageSource source) async {
    setState(() {
      isImageLoading = true;
    });
    File? noteImage;

    final XFile? image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      if (imageUrl.isNotEmpty) {
        _deleteImageFromStorage();
      }
      noteImage = File(image.path);
      final imageBaseName = path.basename(noteImage.path);
      final Reference ref =
          FirebaseStorage.instance.ref('notes/').child(imageBaseName);
      await ref.putFile(noteImage);
      imageUrl = await ref.getDownloadURL();

      print('image url from method = $imageUrl');
    }
    setState(() {
      isImageLoading = false;
    });
  }

  void _deleteImageFromStorage() async {
    if (imageUrl.isNotEmpty) {
      final Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      imageUrl = '';
      setState(() {});
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (context) {
              return CameraBottomSheet(
                onCameraTap: () => _getAndUploadImage(ImageSource.camera),
                onGalleryTap: () => _getAndUploadImage(ImageSource.gallery),
              );
            },
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
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
                NoteAddOrUpdateNoteEvent(
                  id: widget.note.id!,
                  categoryId: widget.categoryId,
                  title: _titleController.text,
                  body: _noteController.text,
                  color: _noteColor,
                  imageUrl: imageUrl,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteAddedOrUpdatedSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Note saved successfully, refresh to see changes'),
              ),
            );

            Navigator.pop(context);
          } else if (state is NoteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          color: Color(_noteColor.value), // Use the selected background color
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              if (isImageLoading)
                const SizedBox(
                  height: 300,
                  child: Loader(),
                ),
              if (imageUrl != '')
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Image.network(
                      imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                    GestureDetector(
                      onTap: _deleteImageFromStorage,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
