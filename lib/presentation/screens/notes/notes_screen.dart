import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/core/app_constants.dart';
import 'package:flutter_fire/core/widgets/loader.dart';
import 'package:flutter_fire/data/models/note_model.dart';
import 'package:flutter_fire/logic/note/note_bloc.dart';

class NotesScreen extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const NotesScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoryName} Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppConstants.addUpdateNoteScreen,
              arguments: {
                "note": NoteModel(
                  title: '',
                  body: '',
                  color: Colors.white,
                ),
                "categoryId": widget.categoryId,
              });
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<NoteBloc>(context).add(
            NoteGetAllNotesEvent(
              categoryId: widget.categoryId,
            ),
          );
        },
        child: BlocConsumer<NoteBloc, NoteState>(
          listener: (context, state) {
            if (state is NoteErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is NoteAddedSuccessState) {
              BlocProvider.of<NoteBloc>(context).add(
                NoteGetAllNotesEvent(
                  categoryId: widget.categoryId,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NoteGetAllNotesSuccessState) {
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text(
                    'No Notes Found',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // TODO: Add update note screen
                      // Navigator.pushNamed(context, AppConstants.addUpdateNoteScreen,
                      //     arguments: {
                      //       'categoryId': widget.categoryId,
                      //       'note': NoteModel(title: '', body: '', color: Colors.white),
                      //     });
                    },
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
                          color: Color(state.notes[index].color.value),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(state.notes[index].title),
                              subtitle: Text(
                                state.notes[index].body,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(height: 1.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is NoteLoadingState) {
              return const Loader();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
