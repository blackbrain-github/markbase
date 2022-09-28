import 'package:Markbase/dome/show.dart';
import 'package:Markbase/dome/variable_notifier.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/ui_logic/common/app.dart';
import 'package:flutter/material.dart';

class DatabaseScreenLogic {
  final BuildContext context;
  final VariableNotifier<Collection> currentCollection;

  List<Collection> previousCollections = []; // collections before currentCollection, in order

  String newCollectionTitle = '';

  DatabaseScreenLogic(
    this.context, {
    required this.currentCollection,
  });

  void init() async {
    List<Collection> cachedCollections = getCachedCollectionsForPath('');
    List<Note> cachedNotes = getCachedNotesForPath('');

    currentCollection.set(
      Collection(
        id: currentCollection.get.id,
        title: currentCollection.get.title,
        path: currentCollection.get.path,
        parentPath: currentCollection.get.parentPath,
        collections: cachedCollections,
        collectionCount: cachedCollections.length,
        notes: cachedNotes,
        noteCount: cachedNotes.length,
      ),
    );

    List<Collection> collections = await getCollectionsForPath('');
    List<Note> notes = await getNotesForPath('');

    currentCollection.set(
      Collection(
        id: currentCollection.get.id,
        title: currentCollection.get.title,
        path: currentCollection.get.path,
        parentPath: currentCollection.get.parentPath,
        collections: collections,
        collectionCount: collections.length,
        notes: notes,
        noteCount: notes.length,
      ),
    );
  }

  // Get cached
  List<Collection> getCachedCollectionsForPath(String parentPath) {
    var cachedCollectionsForPath = AppVariables.appState.read('collections($parentPath)');

    if (cachedCollectionsForPath != null) {
      List<Collection> _collections = [];
      for (var i = 0; i < cachedCollectionsForPath.length; i++) {
        _collections.add(Collection.fromMap(cachedCollectionsForPath[i]));
      }
      return _collections;
    }
    return [];
  }

  List<Note> getCachedNotesForPath(String parentPath) {
    var cachedNotesForPath = AppVariables.appState.read('notes($parentPath)');

    if (cachedNotesForPath != null) {
      List<Note> _notes = [];
      for (var i = 0; i < cachedNotesForPath.length; i++) {
        _notes.add(Note.fromMap(cachedNotesForPath[i]));
      }
      return _notes;
    }
    return [];
  }

  // Get from server
  Future<List<Collection>> getCollectionsForPath(String path) async {
    return await Database.get.collections(path).then((_collections) async {
      await cacheCollectionsForPath(_collections);
      return _collections;
    }).catchError((e) {
      throw e;
    });
  }

  Future<List<Note>> getNotesForPath(String path) async {
    return await Database.get.notes(path).then((_notes) async {
      await cacheNotesForPath(_notes);
      return _notes;
    }).catchError((e) {
      throw e;
    });
  }

  // Cache
  Future<void> cacheCollectionsForPath(List<Collection> collectionsToCache) async {
    List<Map<String, dynamic>> collectionsAsMap = [];
    for (var i = 0; i < collectionsToCache.length; i++) {
      collectionsAsMap.add(collectionsToCache[i].toMap());
    }
    await AppVariables.appState.write('collections(${collectionsToCache.first.parentPath})', collectionsAsMap);
  }

  Future<void> cacheNotesForPath(List<Note> notesToCache) async {
    // Save to cache
    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < notesToCache.length; i++) {
      notesAsMap.add(notesToCache[i].toMap());
    }
    await AppVariables.appState.write('notes(${currentCollection.get.parentPath})', notesAsMap);
  }

  // Navigation
  void goToCollection(Collection collection) async {
    previousCollections.add(currentCollection.get);
    currentCollection.set(collection);

    // Get cached
    currentCollection.set(
      Collection.mergeFields(
        currentCollection.get,
        collections: getCachedCollectionsForPath(currentCollection.get.path),
      ),
      notify: false,
    );
    currentCollection.set(
      Collection.mergeFields(
        currentCollection.get,
        notes: getCachedNotesForPath(currentCollection.get.path),
      ),
      notify: true,
    );

    // Get server
    currentCollection.set(
      Collection.mergeFields(
        currentCollection.get,
        collections: await getCollectionsForPath(currentCollection.get.path),
      ),
      notify: false,
    );
    currentCollection.set(
      Collection.mergeFields(
        currentCollection.get,
        notes: await getNotesForPath(currentCollection.get.path),
      ),
      notify: true,
    );
  }

  void goBack() {
    currentCollection.set(previousCollections.last);
    previousCollections.removeAt(previousCollections.length - 1);
  }

  Future<void> createNewCollection() async {
    if (newCollectionTitle != '') {
      try {
        if (currentCollection.get.isRoot()) {
          Collection newCollection = await Database.create.collection(title: newCollectionTitle);

          List<Collection> updatedCollections = currentCollection.get.collections ?? [];
          updatedCollections.add(newCollection);
          currentCollection.set(Collection.mergeFields(currentCollection.get, collections: updatedCollections));
        } else {
          Collection newCollection = await Database.create.collection(
            title: newCollectionTitle,
            parentPath: currentCollection.get.parentPath!,
            parentId: currentCollection.get.id!,
          );

          List<Collection> updatedCollections = currentCollection.get.collections ?? [];
          updatedCollections.add(newCollection);
          currentCollection.set(Collection.mergeFields(currentCollection.get, collections: updatedCollections));
        }

        Navigator.of(context).maybePop();
      } catch (e) {
        Show(context).errorMessage(message: 'Something went wrong');
      }
    } else {
      Show(context).errorMessage(message: 'Name cannot be empty');
    }
  }

  Future<void> refresh() async {
    await Database.get.collections(currentCollection.get.parentPath ?? '').then((_collections) {
      cacheCollectionsForPath(_collections);
      currentCollection.set(currentCollection.get..collections = _collections);
    });
    await Database.get.notes(currentCollection.get.parentPath ?? '').then((_notes) {
      cacheNotesForPath(_notes);
      currentCollection.set(currentCollection.get..notes = _notes);
    });
  }
}
