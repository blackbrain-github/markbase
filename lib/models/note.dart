import 'package:Markbase/models/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  String body;
  String inCollectionPath;
  DateTime? lastEdited;

  Note({
    required this.id,
    required this.body,
    required this.inCollectionPath,
    required this.lastEdited,
  });

  String get title => body.split("\n").first;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inCollectionPath': inCollectionPath,
      'body': body,
      'lastEdited': lastEdited != null ? lastEdited!.toIso8601String() : null,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      inCollectionPath: map['inCollectionPath'],
      body: map['body'],
      lastEdited: DateTime.parse(map['lastEdited']),
    );
  }

  static Note blank(Collection inCollection) {
    return Note(
      id: "",
      body: "",
      inCollectionPath: inCollection.path,
      lastEdited: null,
    );
  }

  static Note fromQueryDocumentSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Note(
      id: snapshot.id,
      inCollectionPath: snapshot.data()['inCollectionPath'],
      body: snapshot.data()['body'],
      lastEdited: snapshot.data()["lastEdited"] is String ? DateTime.parse(snapshot.data()["lastEdited"]) : snapshot.data()["lastEdited"].toDate(),
    );
  }

  static Note fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Note(
      id: snapshot.id,
      inCollectionPath: snapshot.data()?['inCollectionPath'],
      body: snapshot.data()?['body'],
      lastEdited: snapshot.data()?["lastEdited"] is String ? DateTime.parse(snapshot.data()?["lastEdited"]) : snapshot.data()?["lastEdited"].toDate(),
    );
  }

  static List<Note> manyFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Note> notes = [];
    for (var doc in snapshot.docs) {
      notes.add(Note.fromQueryDocumentSnapshot(doc));
    }

    return notes;
  }

  static Note fromDocumentReference(DocumentReference<Map<String, dynamic>> documentReference) {
    return Note(
      id: documentReference.id,
      inCollectionPath: documentReference.path,
      body: '',
      lastEdited: DateTime.now(),
    );
  }
}
