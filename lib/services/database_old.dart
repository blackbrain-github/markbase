/* import 'package:Markbase/ui_logic/common/app.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:firebase_database/firebase_database.dart';

class Database {
  static FirebaseDatabase realtimeDatabase = FirebaseDatabase.instance;

  // All collections
  static String rootPath = 'users/${AppUser.id}/root';

  // Path for collection
  static String collectionPath(String path) {
    String ref = "";

    if (path == "/") {
      ref = "/";
    } else {
      ref = path.replaceAll("/", "/collections/");
    }

    return 'users/${AppUser.id}/root$ref';
  }

  // Path for notes for collection
  static String notesForCollection(String path) {
    return "${collectionPath(path)}/notes";
  }

  // Path for notes for collection
  static String notePath(String noteId) {
    return 'users/${AppUser.id}/notes/$noteId';
  }

  // Functions
  static Future<Collection?> fetchNotebase() async {
    try {
      if (AppUser.id != null) {
        DataSnapshot dataSnapshot = await realtimeDatabase.ref(rootPath).get();
        if (!dataSnapshot.exists) {
          return null;
        }
        return Collection.fromFirebase(dataSnapshot.value);
      }
      throw CustomDatabaseException("fetchNotebase()", "Error getting users notebase, no user id exists", "");
    } catch (e) {
      throw CustomDatabaseException("fetchNotebase()", "Error getting users notebase (all collections) from database", e);
    }
  }

  static Future<Collection> fetchCollection(String path) async {
    try {
      DataSnapshot dataSnapshot = await realtimeDatabase.ref(collectionPath(path)).get();
      return Collection.fromFirebase(dataSnapshot.value);
    } catch (e) {
      throw CustomDatabaseException("fetchCollections()", "Error getting collection from database", e);
    }
  }

  static Future<Collection> getNotesForCollection(Collection collection) async {
    try {
      List<Note> notes = [];
      for (var i = 0; i < collection.noteIds.length; i++) {
        DataSnapshot dataSnapshot = await realtimeDatabase.ref(notePath(collection.noteIds.elementAt(i))).get();
        notes.add(Note.fromFirebase(dataSnapshot, path: collection.path));
      }
      collection.notes = notes;
      return collection;
    } catch (e) {
      throw CustomDatabaseException("fetchCollections()", "Error getting users collections from database", e);
    }
  }

  static Future<Note> newNote(String path) async {
    try {
      String? newNoteKey = realtimeDatabase.ref(collectionPath(path)).push().key;

      if (newNoteKey != null) {
        Map<String, dynamic> noteData = {
          "id": newNoteKey,
          "path": path,
          "title": "",
          "body": "",
        };

        Note note = Note(id: newNoteKey, body: "", path: path);

        await realtimeDatabase.ref('${notesForCollection(path)}/$newNoteKey').update(noteData);
        await realtimeDatabase.ref(notesForCollection(path)).update({newNoteKey: true});

        return note;
      }
      throw CustomDatabaseException("newNote()", "Error creating new note, key is null", "");
    } catch (e) {
      throw CustomDatabaseException("newNote()", "Error creating new note", e);
    }
  }

  static Future<Collection> newCollection(Collection collection) async {
    try {
      await realtimeDatabase.ref(collectionPath(collection.path)).set({
        "title": collection.title,
        "path": collection.path,
      });

      return collection;
    } catch (e) {
      throw CustomDatabaseException("newNote()", "Error creating new note", e);
    }
  }

  static Future<void> saveNoteTitle(Note note) async {
    try {
      await realtimeDatabase.ref(notePath(note.id)).update({"title": note.title});
    } catch (e) {
      throw CustomDatabaseException("saveNoteTitle()", "Error saving notes title", e);
    }
  }

  static Future<void> saveNoteBody(Note note) async {
    try {
      await realtimeDatabase.ref(notePath(note.id)).update({"body": note.body});
    } catch (e) {
      throw CustomDatabaseException("saveNoteTitle()", "Error saving notes title", e);
    }
  }
}

class CustomDatabaseException implements Exception {
  String methodName;
  String message;
  dynamic e;
  CustomDatabaseException(this.methodName, this.message, this.e);

  @override
  String toString() {
    return "[in Database -> $methodName]: \n $message \n Detailed Error: $e";
  }
}
 */