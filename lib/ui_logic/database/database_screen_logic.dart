import 'package:Markbase/dome/cache_master.dart';
import 'package:Markbase/dome/navigate.dart';
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/cached_object.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/note/note_screen.dart';
import 'package:flutter/material.dart';

class DatabaseScreenLogic {
  VariableNotifier<List<Collection>> collections = VariableNotifier<List<Collection>>([]);
  VariableNotifier<List<Note>> notes = VariableNotifier<List<Note>>([]);

  // Only a reference for bottom bar and refresh
  VariableNotifier<Collection> currentCollection = VariableNotifier<Collection>(Collection.root());
  List<Collection> previousCollection = [Collection.root()];

  DatabaseScreenLogic();

  Future<void> loadCollectionsAndNotesInRoot() async {
    String path = '/';

    await loadCollectionsForPath(path);
    await loadNotesForPath(path);
  }

  Future<void> loadCollection(Collection collection) async {
    collections.set([]);
    notes.set([]);

    previousCollection.add(currentCollection.get);
    currentCollection.set(collection, notify: true);
    await loadCollectionsForPath(collection.path);
    await loadNotesForPath(collection.path);
  }

  Future<void> loadPreviousCollection() async {
    if (currentCollection.get.parentPath != null) {
      collections.set([]);
      notes.set([]);

      currentCollection.set(previousCollection.last);
      previousCollection.removeLast();

      await loadCollectionsForPath(currentCollection.get.path);
      await loadNotesForPath(currentCollection.get.path);
    }
  }

  Future<void> loadCollectionsForPath(String path, {bool bypassCache = false}) async {
    // Example: if path = '/Notes', it will get collections inside this path
    // Gets cached collections and checks whether they are still valid (not expired)
    // If they are expired, will load collections from server
    // If not, loads cached collections
    if (bypassCache) {
      List<Collection> _collectionsFromServer = await Database.get.collections(path);
      await CacheMaster.cache.collectionsForPath(_collectionsFromServer, path);
      collections.set(_collectionsFromServer, notify: true);
      return;
    }
    CachedObject<List<Collection>> _collections = CacheMaster.get.collectionsForPath(path);
    if (_collections.object.isEmpty || _collections.isExpired()) {
      List<Collection> _collectionsFromServer = await Database.get.collections(path);
      await CacheMaster.cache.collectionsForPath(_collectionsFromServer, path);

      // Checking the path here prevents wrong collections loaded if the user is switching collections fast
      if (path == currentCollection.get.path) {
        collections.set(_collectionsFromServer, notify: true);
      }
    } else {
      collections.set(_collections.object, notify: true);
    }
  }

  Future<void> loadNotesForPath(String path, {bool bypassCache = false}) async {
    // Example: if path = '/Notes', it will get notes inside this path
    // Gets cached notes and checks whether they are still valid (not expired)
    // If they are expired, will load notes from server
    // If not, loads cached notes
    if (bypassCache) {
      List<Note> _notesFromServer = await Database.get.notes(path);
      await CacheMaster.cache.notesForPath(_notesFromServer, path);
      notes.set(_notesFromServer, notify: true);
    }
    CachedObject<List<Note>> _notes = CacheMaster.get.notesForPath(path);
    if (_notes.object.isEmpty || _notes.isExpired()) {
      List<Note> _notesFromServer = await Database.get.notes(path);
      await CacheMaster.cache.notesForPath(_notesFromServer, path);

      // Checking the path here prevents wrong notes loaded if the user is switching collections fast
      if (path == currentCollection.get.path) {
        notes.set(_notesFromServer, notify: true);
      }
    } else {
      notes.set(_notes.object, notify: true);
    }
  }

  Future<void> createNewCollection(BuildContext context, String title) async {
    try {
      Collection collection = await Database.create.collection(
        title: title,
        parentId: currentCollection.get.id,
        parentPath: currentCollection.get.path,
      );

      Navigator.of(context).maybePop(collection);
    } catch (e) {
      throw 'Something went wrong trying to create collection.';
    }
  }

  Future<void> createNewNote(BuildContext context) async {
    try {
      Note newNote = await Database.create.note(
        currentCollection.get.path,
        currentCollection.get.id,
      );
      List<Note> _notes = notes.get;
      _notes.add(newNote);
      notes.set(_notes, notify: true);
      var r = await Navigate(context).to(NoteScreen(newNote));
    } catch (e) {
      Show(context).errorMessage(message: e.toString());
    }
  }

  Future<void> refresh() async {
    await loadCollectionsForPath(currentCollection.get.path, bypassCache: true);
    await loadNotesForPath(currentCollection.get.path, bypassCache: true);
  }
}
