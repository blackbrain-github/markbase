import 'package:Markbase/models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Collection {
  String? id;
  String? title;
  String? path; // always in format '/collection1/collection2/collection3', not slash at the end
  String? parentPath; // always in format '/collection1/collection2', not slash at the end, "" if in root
  int? collectionCount;
  int? noteCount;
  List<Collection>? collections;
  List<Note>? notes;

  Collection({
    required this.id,
    required this.title,
    required this.path,
    required this.parentPath,
    required this.collectionCount,
    required this.noteCount,
    this.collections,
    this.notes,
  });

  static Collection empty() {
    return Collection(
      id: null,
      title: null,
      path: null,
      parentPath: null,
      collectionCount: null,
      noteCount: null,
    );
  }

  bool isEmpty() => id == null && title == null && path == null && parentPath == null && collectionCount == null && noteCount == null && collections == null && notes == null;

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> collectionsAsMap = [];
    for (var i = 0; i < (collections?.length ?? 0); i++) {
      collectionsAsMap.add(collections![i].toMap());
    }

    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < (notes?.length ?? 0); i++) {
      notesAsMap.add(notes![i].toMap());
    }

    return {
      'id': id,
      'title': title,
      'path': path,
      'parentPath': parentPath,
      'collectionCount': collectionCount,
      'noteCount': noteCount,
      'collections': collectionsAsMap,
      'notes': notesAsMap,
    };
  }

  static Collection fromMap(Map<String, dynamic> map) {
    List<Collection> collections = [];
    for (var i = 0; i < map['collections'].length; i++) {
      collections.add(Collection.fromMap(map['collections'][i]));
    }

    List<Note> notes = [];
    for (var i = 0; i < map['notes'].length; i++) {
      notes.add(Note.fromMap(map['notes'][i]));
    }

    return Collection(
      id: map['id'],
      title: map['title'],
      path: map['path'],
      parentPath: map['parentPath'],
      collectionCount: map['collectionCount'],
      noteCount: map['noteCount'],
      collections: collections,
      notes: notes,
    );
  }

  // Formats whole database to one Collection inside which are all of its children
  static Collection fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Collection(
      id: snapshot.id,
      title: snapshot.data()['title'],
      path: snapshot.data()['path'],
      parentPath: snapshot.data()['parentPath'],
      collectionCount: snapshot.data()['collectionCount'],
      noteCount: snapshot.data()['noteCount'],
    );
  }

  static List<Collection> manyFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Collection> collections = [];
    for (var doc in snapshot.docs) {
      collections.add(fromSnapshot(doc));
    }

    return collections;
  }
}
