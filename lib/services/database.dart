// Packages
import 'dart:async';
import 'dart:io';

import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/models/user.dart';
import 'package:Markbase/ui_logic/common/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

/// Firebase Firestore is used as database

class Database {
  static Get get = Get();
  static Create create = Create();
  static Modify modify = Modify();
  static Add add = Add();
  static Delete delete = Delete();

  // For properly displaying errors
  FlutterError _error(String operation, String data, dynamic e) {
    return FlutterError('Server error, $operation $data: $e');
  }

  FlutterError _authError() {
    return FlutterError('Auth error, user not authenticated in app');
  }

  // Authentication
  final User? _authenticatedUser = FirebaseAuth.instance.currentUser;

  bool _isAuthenticated() {
    if (_authenticatedUser != null) {
      return true;
    }
    return false;
  }

  // Used document
  String _userStringRef() => StringConstants.usersCollectionRef + '/' + _authenticatedUser!.uid;

  CollectionReference<Map<String, dynamic>> _usersRef() => FirebaseConstants.firestore.collection(StringConstants.usersCollectionRef);

  CollectionReference<Map<String, dynamic>> _notesRef() => FirebaseConstants.firestore.collection(_userStringRef() + '/' + StringConstants.notesCollectionRef);

  CollectionReference<Map<String, dynamic>> _collectionsRef() => FirebaseConstants.firestore.collection(_userStringRef() + '/' + StringConstants.collectionCollectionRef);
}

class Get extends Database {
  /// User \\\
  Future<UserModel> user() async {
    return _isAuthenticated()
        ? _isAuthenticated()
            ? await _usersRef().doc(_authenticatedUser!.uid).get().then(
                (doc) {
                  return UserModel.fromFirestore(doc);
                },
              ).catchError((e) => throw _error('Get', 'user', e))
            : throw _authError()
        : throw _authError();
  }

  Future<String> userUsername() async {
    return _isAuthenticated()
        ? await _usersRef().doc(_authenticatedUser!.uid).get().then(
            (doc) {
              return doc.data()!['username'];
            },
          ).catchError((e) => throw _error('GET', 'userUsername', e))
        : throw _authError();
  }

  /// Path given in 'collection/collection' format, not '/collection/collection'
  Future<List<Note>> notes(String inCollectionPath) async {
    return _isAuthenticated()
        ? _isAuthenticated()
            ? await _notesRef().where('inCollectionPath', isEqualTo: inCollectionPath).get().then(
                (snapshot) {
                  return Note.manyFromSnapshot(snapshot);
                },
              ).catchError((e) => throw _error('Get', 'notes', e))
            : throw _authError()
        : throw _authError();
  }

  Future<List<Collection>> collections(String parentPath) async {
    return _isAuthenticated()
        ? _isAuthenticated()
            ? await _collectionsRef().where('parentPath', isEqualTo: parentPath).get().then(
                (snapshot) {
                  return Collection.manyFromSnapshot(snapshot);
                },
              ).catchError((e) => throw _error('Get', 'collections', e))
            : throw _authError()
        : throw _authError();
  }

  Future<List<Note>> recentlyEditedNotes() async {
    return _isAuthenticated()
        ? _isAuthenticated()
            ? await _notesRef().orderBy('lastEdited').limit(10).get().then(
                (snapshot) {
                  return Note.manyFromSnapshot(snapshot);
                },
              ).catchError((e) => throw _error('Get', 'notes', e))
            : throw _authError()
        : throw _authError();
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
        try {
          profileImageUrl = await FirebaseStorage.instance.ref('profile_images/${FirebaseAuth.instance.currentUser?.uid}').putFile(profileImage).then(
                (p0) async => await p0.ref.getDownloadURL(),
              );
        } catch (e) {
          print("profile image failed");
          print(e);
        }
      }

      registerBatch.set(
        _usersRef().doc(_authenticatedUser!.uid),
        {
          'created_at': FieldValue.serverTimestamp(), // Adds timestamp in server when created
          'account_type': 'user',
          'id': _authenticatedUser!.uid,
          'username': username.toLowerCase(),
          'email': _authenticatedUser!.email,
          'full_name': fullName,
          'profile_image': profileImageUrl ?? '',
          'private': true,
          'friends': [],
          'sent_requests': [],
          'received_requests': [],
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

  Future<Note> note(String inCollectionPath, String collectionId) async {
    return _isAuthenticated()
        ? await _notesRef()
            .add({
              'body': '',
              'inCollectionPath': inCollectionPath,
              'lastEdited': FieldValue.serverTimestamp(),
            })
            .catchError((e) => throw _error('POST', 'data', e))
            .then((snapshot) async {
              if (collectionId != '') {
                await _collectionsRef().doc(collectionId).update({'noteCount': FieldValue.increment(1)});
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
              'path': 'parentPath/$title',
              'parentPath': parentPath,
              'collectionCount': 0,
              'noteCount': 0,
            })
            .catchError((e) => throw _error('POST', 'data', e))
            .then((snapshot) async {
              if (parentId != '') {
                await _collectionsRef().doc(parentId).update({'collectionCount': FieldValue.increment(1)});
              }

              return Collection(
                id: snapshot.id,
                title: title,
                path: '${parentPath ?? ''}/$title',
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
    print("trying");
    FirebaseStorage storage = FirebaseStorage.instance;

    await storage.ref('profile_images/${FirebaseAuth.instance.currentUser?.uid}').putFile(imageFile).then((p0) async {
      String url = await p0.ref.getDownloadURL();

      WriteBatch wb = FirebaseFirestore.instance.batch();

      wb.update(
        _usersRef().doc(_authenticatedUser?.uid),
        {
          "profile_image_url": url,
        },
      );

      await wb
          .commit()
          .then(
            (_) {},
          )
          .catchError((e) {
        print(e);
        throw _error("MODIFY", "User profile photo", e);
      });
    }).catchError((e) {
      print(e);
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
          _usersRef().doc(_authenticatedUser!.uid),
          {
            'profile_image_url': url,
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
  Future<void> note(Note note) async {
    if (_isAuthenticated()) {
      WriteBatch wb = FirebaseFirestore.instance.batch();
      wb.delete(_notesRef().doc(note.id));

      QuerySnapshot<Map<String, dynamic>> inCollection = await _collectionsRef()
          .where(
            'inCollectionPath',
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
