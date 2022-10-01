// Packages
import 'dart:async';
import 'dart:io';

import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// Firebase Firestore is used as database

class CollectionNames {
  static const String usersCollectionRef = "users";
  static const String notesCollectionRef = "notes";
  static const String collectionCollectionRef = "collections";
}

class Database {
  static Get get = Get();
  static Create create = Create();
  static Modify modify = Modify();
  static Add add = Add();
  static Delete delete = Delete();

  // For properly displaying errors
  FlutterError _error(String operation, String data, dynamic e) {
    FirebaseCrashlytics.instance.recordFlutterError(FlutterErrorDetails(exception: e));
    return FlutterError('Server error, $operation $data: $e');
  }

  FlutterError _authError() {
    FirebaseCrashlytics.instance.recordFlutterError(const FlutterErrorDetails(exception: 'Auth error, user not authenticated in app'));
    return FlutterError('Auth error, user not authenticated in app');
  }

  bool _isAuthenticated() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

  // Used document
  String _userStringRef() => CollectionNames.usersCollectionRef + '/' + FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> _usersRef() => FirebaseFirestore.instance.collection(CollectionNames.usersCollectionRef);

  CollectionReference<Map<String, dynamic>> _notesRef() => FirebaseFirestore.instance.collection(_userStringRef() + '/' + CollectionNames.notesCollectionRef);

  CollectionReference<Map<String, dynamic>> _collectionsRef() => FirebaseFirestore.instance.collection(_userStringRef() + '/' + CollectionNames.collectionCollectionRef);
}

class Get extends Database {
  /// User \\\
  Future<UserModel> user() async {
    return _isAuthenticated()
        ? await _usersRef().doc(FirebaseAuth.instance.currentUser!.uid).get().then(
            (doc) {
              if (doc.data() == null) {
                throw 'not-found';
              } else {
                return UserModel.fromFirestore(doc);
              }
            },
          ).catchError((e) => throw e)
        : throw _authError();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userAsStream() {
    if (_isAuthenticated()) {
      return _usersRef().doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
    } else {
      throw _authError();
    }
  }

  Future<String> userUsername() async {
    return _isAuthenticated()
        ? await _usersRef().doc(FirebaseAuth.instance.currentUser!.uid).get().then(
            (doc) {
              return doc.data()!['username'];
            },
          ).catchError((e) => throw _error('GET', 'userUsername', e))
        : throw _authError();
  }

  /// Path given in 'collection/collection' format, not '/collection/collection'
  Future<List<Note>> notes(String inCollectionPath) async {
    return _isAuthenticated()
        ? await _notesRef().where('inCollectionPath', isEqualTo: inCollectionPath).get().then(
            (snapshot) {
              return Note.manyFromSnapshot(snapshot);
            },
          ).catchError((e) => throw _error('Get', 'notes', e))
        : throw _authError();
  }

  Future<List<Collection>> collections(String parentPath) async {
    return _isAuthenticated()
        ? await _collectionsRef().where('parentPath', isEqualTo: parentPath).get().then(
            (snapshot) {
              return Collection.manyFromSnapshot(snapshot);
            },
          ).catchError((e) => throw _error('Get', 'collections', e))
        : throw _authError();
  }

  Future<List<Note>> recentlyEditedNotes() async {
    return _isAuthenticated()
        ? await _notesRef().orderBy('lastEdited', descending: true).limit(10).get().then(
            (snapshot) {
              return Note.manyFromSnapshot(snapshot);
            },
          ).catchError((e) => throw _error('Get', 'notes', e))
        : throw _authError();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> recentlyEditedNotesAsStream() {
    return _isAuthenticated() ? _notesRef().orderBy('lastEdited').limit(10).snapshots() : throw _authError();
  }
}

class Create extends Database {
  Future<void> user(String username, String fullName, {File? profileImage}) async {
    if (_isAuthenticated()) {
      // using batch write since writing twice
      WriteBatch registerBatch = FirebaseFirestore.instance.batch();

      String? profileImageUrl;
      if (profileImage != null) {
        // Upload profile image to storage
        profileImageUrl = await FirebaseStorage.instance.ref('profile_images/${FirebaseAuth.instance.currentUser?.uid}').putFile(profileImage).then(
              (p0) async => await p0.ref.getDownloadURL(),
            );
      }

      registerBatch.set(
        _usersRef().doc(FirebaseAuth.instance.currentUser!.uid),
        {
          'createdAt': FieldValue.serverTimestamp(),
          'id': FirebaseAuth.instance.currentUser!.uid,
          'username': username.toLowerCase(),
          'email': FirebaseAuth.instance.currentUser!.email,
          'fullName': fullName,
          'profileImageUrl': profileImageUrl ?? '',
        },
        SetOptions(
          merge: true,
        ),
      );

      await registerBatch
          .commit()
          .then(
            (_) {},
          )
          .catchError((e) => throw _error('POST', 'data', e));
    } else {
      throw _authError();
    }
  }

  Future<Note> note(String parentPath, String? parentCollectionId) async {
    return _isAuthenticated()
        ? await _notesRef()
            .add({
              'body': '',
              'inCollectionPath': parentPath,
              'lastEdited': FieldValue.serverTimestamp(),
            })
            .catchError((e) => throw _error('POST', 'data', e))
            .then((snapshot) async {
              if (parentCollectionId != null) {
                await _collectionsRef().doc(parentCollectionId).update({'noteCount': FieldValue.increment(1)});
              }
              return Note.fromDocumentSnapshot(await snapshot.get());
            })
        : throw _authError();
  }

  Future<Collection> collection({required String title, String? parentId, String? parentPath}) async {
    return _isAuthenticated()
        ? await _collectionsRef()
            .add({
              'title': title,
              'path': parentPath == '/' ? '/$title' : '$parentPath/$title',
              'parentPath': parentPath,
              'collectionCount': 0,
              'noteCount': 0,
            })
            .catchError((e) => throw _error('POST', 'data', e))
            .then((snapshot) async {
              if (parentId != null) {
                await _collectionsRef().doc(parentId).update({'collectionCount': FieldValue.increment(1)});
              }

              return Collection(
                id: snapshot.id,
                title: title,
                path: parentPath == '/' ? '/$title' : '$parentPath/$title',
                parentPath: parentPath ?? '',
                collectionCount: 0,
                noteCount: 0,
              );
            })
        : throw _authError();
  }
}

class Modify extends Database {
  Future<void> userProfileImage(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    await storage.ref('profile_images/${FirebaseAuth.instance.currentUser?.uid}').putFile(imageFile).then((p0) async {
      String url = await p0.ref.getDownloadURL();

      WriteBatch wb = FirebaseFirestore.instance.batch();

      wb.update(
        _usersRef().doc(FirebaseAuth.instance.currentUser?.uid),
        {
          "profileImageUrl": url,
        },
      );

      await wb
          .commit()
          .then(
            (_) {},
          )
          .catchError((e) {
        throw _error("MODIFY", "User profile photo", e);
      });
    }).catchError((e) {
      throw _error("MODIFY", "User profile photo", e);
    });
  }

  Future<void> note(Note note) async {
    return _isAuthenticated()
        ? await _notesRef()
            .doc(note.id)
            .update(note.toMap())
            .catchError(
              (e) => throw _error('Modify', 'note', e),
            )
            .then((_) {})
        : throw _authError();
  }
}

class Add extends Database {
  Future<void> userProfileImage(File imageFile) async {
    if (_isAuthenticated()) {
      FirebaseStorage storage = FirebaseStorage.instance;

      await storage.ref('profile_images/${FirebaseAuth.instance.currentUser?.uid}').putFile(imageFile).then((p0) async {
        String url = await p0.ref.getDownloadURL();

        WriteBatch wb = FirebaseFirestore.instance.batch();

        wb.update(
          _usersRef().doc(FirebaseAuth.instance.currentUser!.uid),
          {
            'profileImageUrl': url,
          },
        );

        await wb
            .commit()
            .then(
              (_) {},
            )
            .catchError((e) => throw _error('PATCH', 'userProfileImage', e));
      }).catchError((e) => throw _error('PATCH', 'userProfileImage', e));
    } else {
      throw _authError();
    }
  }
}

class Delete extends Database {
  Future<void> collection(Collection collection) async {
    if (_isAuthenticated()) {
      WriteBatch wb = FirebaseFirestore.instance.batch();
      await _collectionsRef().doc(collection.id).delete();

      QuerySnapshot<Map<String, dynamic>> notes = await _notesRef().where('inCollectionPath', isGreaterThanOrEqualTo: collection.path).get();

      for (var note in notes.docs) {
        wb.delete(_notesRef().doc(note.id));
      }

      QuerySnapshot<Map<String, dynamic>> inCollection = await _collectionsRef()
          .where(
            'path',
            isEqualTo: collection.parentPath,
          )
          .get();

      if (inCollection.docs.isNotEmpty) {
        wb.update(inCollection.docs.first.reference, {
          'collectionCount': FieldValue.increment(-1),
        });
      }

      QuerySnapshot<Map<String, dynamic>> allChildCollections = await _collectionsRef()
          .where(
            'path',
            isGreaterThanOrEqualTo: collection.parentPath,
          )
          .get();

      for (var i = 0; i < allChildCollections.size; i++) {
        wb.delete(allChildCollections.docs[i].reference);
      }

      await wb.commit().catchError((e) => throw _error('Delete', 'collection', e));
    } else {
      throw _authError();
    }
  }

  Future<void> note(Note note) async {
    if (_isAuthenticated()) {
      WriteBatch wb = FirebaseFirestore.instance.batch();
      wb.delete(_notesRef().doc(note.id));

      QuerySnapshot<Map<String, dynamic>> inCollection = await _collectionsRef()
          .where(
            'path',
            isEqualTo: note.inCollectionPath,
          )
          .get();

      if (inCollection.docs.isNotEmpty) {
        wb.update(inCollection.docs.first.reference, {
          'noteCount': FieldValue.increment(-1),
        });
      }

      await wb.commit().catchError((e) => throw _error('Delete', 'note', e));
    } else {
      throw _authError();
    }
  }
}
