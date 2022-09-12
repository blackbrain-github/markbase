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
  final VariableNotifier<List<Collection>> currentCollectionCollections;
  final VariableNotifier<List<Note>> currentCollectionNotes;

  final VariableNotifier<bool> collectionsLoading;
  final VariableNotifier<bool> notesLoading;

  List<Collection> history = [];
  int levelIndex = 0;
  Future? notesFuture;

  String newCollectionTitle = '';

  DatabaseScreenLogic(
    this.context, {
    required this.currentCollection,
    required this.currentCollectionCollections,
    required this.currentCollectionNotes,
    required this.collectionsLoading,
    required this.notesLoading,
  });

  // Init
  void loadRootCachedCollectionsAndNotes() {
    loadCachedCollectionsForPath();
    loadCachedNotesForPath();

    history.add(currentCollection.get);
  }

  Future<void> loadRootCollectionsAndNotes() async {
    loadCollectionsForPath(path: '');
    loadNotesForPath(path: '');
  }

  // Cache
  Future<void> cacheCollectionsForPath(List<Collection> collectionsToCache) async {
    List<Map<String, dynamic>> collectionsAsMap = [];
    for (var i = 0; i < collectionsToCache.length; i++) {
      collectionsAsMap.add(collectionsToCache[i].toMap());
    }
    await AppVariables.appState.write('collections(${currentCollection.get.parentPath})', collectionsAsMap);
  }

  Future<void> cacheNotesForPath(List<Note> notesToCache) async {
    // Save to cache
    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < notesToCache.length; i++) {
      notesAsMap.add(notesToCache[i].toMap());
    }
    await AppVariables.appState.write('notes(${currentCollection.get.parentPath})', notesAsMap);
  }

  // Load cached
  void loadCachedCollectionsForPath({String? parentPath}) {
    var cachedCollectionsForPath = AppVariables.appState.read('collections(${parentPath ?? currentCollection.get.parentPath})');

    if (cachedCollectionsForPath != null) {
      List<Collection> _collections = [];
      for (var i = 0; i < cachedCollectionsForPath.length; i++) {
        _collections.add(Collection.fromMap(cachedCollectionsForPath[i]));
      }
      currentCollectionCollections.set(_collections);
    }
  }

  void loadCachedNotesForPath({String? parentPath}) {
    var cachedNotesForPath = AppVariables.appState.read('notes(${parentPath ?? currentCollection.get.parentPath})');

    if (cachedNotesForPath != null) {
      List<Note> _notes = [];
      for (var i = 0; i < cachedNotesForPath.length; i++) {
        _notes.add(Note.fromMap(cachedNotesForPath[i]));
      }

      currentCollectionNotes.set(_notes);
    }
  }

  // Load server
  Future<void> loadCollectionsForPath({String? path}) async {
    collectionsLoading.set(true);
    if (path != null) {
      await Database.get.collections(path).then((_collections) {
        cacheCollectionsForPath(_collections);
        currentCollection.set(currentCollection.get..collections = _collections, notify: false);
        currentCollectionCollections.set(_collections);
      });
    } else {
      await Database.get.collections(currentCollection.get.path!).then((_collections) {
        cacheCollectionsForPath(_collections);
        currentCollection.set(currentCollection.get..collections = _collections, notify: false);
        currentCollectionCollections.set(_collections);
      });
    }
    collectionsLoading.set(false);
  }

  Future<void> loadNotesForPath({String? path}) async {
    notesLoading.set(true);
    if (path != null) {
      await Database.get.notes(path).then((_notes) {
        cacheNotesForPath(_notes);
        currentCollection.set(currentCollection.get..notes = _notes, notify: false);
        currentCollectionNotes.set(_notes);
      });
    } else {
      await Database.get.notes(currentCollection.get.path!).then((_notes) {
        cacheNotesForPath(_notes);
        currentCollection.set(currentCollection.get..notes = _notes, notify: false);
        currentCollectionNotes.set(_notes);
      });
    }
    notesLoading.set(false);
  }

  // Navigation
  void goToCollection(Collection collection) async {
    history.add(collection);
    currentCollection.set(history[levelIndex++]);
    print(levelIndex);

    print("Changed current collection");
    print(currentCollection.get.id);
    print(currentCollection.get.title);
    print(currentCollection.get.title);
    print(currentCollection.get.path);
    print(currentCollection.get.parentPath);

    currentCollectionCollections.set([]);
    currentCollectionNotes.set([]);

    // Get cached
    loadCachedCollectionsForPath();
    loadCachedNotesForPath();

    await loadCollectionsForPath();
    await loadNotesForPath();
  }

  void goBack() {
    print(history.length);
    currentCollection.set(history[history.length - 2]);
    loadCachedCollectionsForPath(parentPath: history[history.length - 2].parentPath);
    loadCachedNotesForPath(parentPath: history[history.length - 2].parentPath);

    List<Collection> updatedHistory = history;
    updatedHistory.removeAt(updatedHistory.length - 1);
    history = updatedHistory;
  }

  Future<void> createNewCollection() async {
    if (newCollectionTitle != '') {
      try {
        if (currentCollection.get.isEmpty()) {
          Collection newCollection = await Database.create.collection(title: newCollectionTitle);

          List<Collection> updatedCollections = currentCollectionCollections.get;
          updatedCollections.add(newCollection);
          currentCollectionCollections.set(updatedCollections.toList());
        } else {
          Collection newCollection = await Database.create.collection(
            title: newCollectionTitle,
            parentPath: currentCollection.get.parentPath!,
            parentId: currentCollection.get.id!,
          );

          List<Collection> updatedCollections = currentCollectionCollections.get;
          updatedCollections.add(newCollection);
          currentCollectionCollections.set(updatedCollections.toList());
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
    print(currentCollection.get.parentPath);
    await Database.get.collections(currentCollection.get.parentPath ?? '').then((_collections) {
      cacheCollectionsForPath(_collections);
      currentCollectionCollections.set(_collections);
    });
    await Database.get.notes(currentCollection.get.parentPath ?? '').then((_notes) {
      cacheNotesForPath(_notes);
      currentCollectionNotes.set(_notes);
    });
  }
}
