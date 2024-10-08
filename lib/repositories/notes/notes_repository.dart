import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/data/models/note_model.dart';

abstract class NoteRepository {
  Future<void> deleteNote(String categoryId, String noteId, String imageUrl);
  Future<void> addOrUpdateNote(String categoryId, NoteModel note);
  Future<List<NoteModel>> getAllNotes(String categoryId);
  Stream<List<NoteModel>> getNotesStream(String categoryId);
}

class NoteRepositoryImpl implements NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<void> deleteNote(
    String categoryId,
    String noteId,
    String imageUrl,
  ) async {
    if (imageUrl.isNotEmpty) {
      await FirebaseStorage.instance.refFromURL(imageUrl).delete();
    }
    await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  @override
  Stream<List<NoteModel>> getNotesStream(String categoryId) {
    return _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('notes')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteModel(
          id: doc.id,
          title: doc['title'],
          body: doc['body'],
          color: _colorFromHex(doc['color']),
          imageUrl: doc['image'],
        );
      }).toList();
    });
  }

  @override
  Future<void> addOrUpdateNote(String categoryId, NoteModel note) async {
    final CollectionReference noteCollection = _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('notes');
    Map<String, dynamic> data = {
      'title': note.title,
      'body': note.body,
      'color': '#${note.color.value.toRadixString(16).padLeft(8, '0')}',
      'image': note.imageUrl,
      'date': DateTime.now(),
    };
    if (note.id == '') {
      await noteCollection.add(data);
    } else {
      await noteCollection.doc(note.id).set(data, SetOptions(merge: true));
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes(String categoryId) async {
    final QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('categories')
        .doc(categoryId)
        .collection('notes')
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs.map((note) {
      return NoteModel(
        id: note.id,
        title: note['title'],
        body: note['body'],
        color: _colorFromHex(note['color']),
        imageUrl: note['image'],
      );
    }).toList();
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
