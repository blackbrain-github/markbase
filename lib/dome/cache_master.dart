import 'package:Markbase/dome/app_specific/app.dart';
import 'package:Markbase/models/cached_object.dart';
import 'package:Markbase/models/collection.dart';
import 'package:Markbase/models/note.dart';

class CacheMaster {
  static final Get get = Get();
  static final Cache cache = Cache();
}

class Get {
  CachedObject<List<Collection>> collectionsForPath(String path) {
    // Example: if path = '/Notes', it will get collections inside this path
    var cachedCollectionsForPath = AppVariables.appState.read('collections($path)');
    var expiryInformation = AppVariables.appState.read('collections($path){expiryInformation}');

    if (cachedCollectionsForPath != null) {
      List<Collection> _collections = [];
      for (var i = 0; i < cachedCollectionsForPath.length; i++) {
        _collections.add(Collection.fromMap(cachedCollectionsForPath[i]));
      }
      return CachedObject(_collections, cachedAt: DateTime.parse(expiryInformation['cachedAt']), expiresAfter: Duration(minutes: expiryInformation['expiresAfter']));
    } else {
      return CachedObject([], cachedAt: DateTime.now(), expiresAfter: Duration.zero);
    }
  }

  CachedObject<List<Note>> notesForPath(String path) {
    // Example: if path = '/Notes', it will get notes inside this path
    var cachedNotesForPath = AppVariables.appState.read('notes($path)');
    var expiryInformation = AppVariables.appState.read('notes($path){expiryInformation}');

    if (cachedNotesForPath != null) {
      List<Note> _notes = [];
      for (var i = 0; i < cachedNotesForPath.length; i++) {
        _notes.add(Note.fromMap(cachedNotesForPath[i]));
      }

      return CachedObject(_notes, cachedAt: DateTime.parse(expiryInformation['cachedAt']), expiresAfter: Duration(minutes: expiryInformation['expiresAfter']));
    } else {
      return CachedObject([], cachedAt: DateTime.now(), expiresAfter: Duration.zero);
    }
  }
}

class Cache {
  Future<void> collectionsForPath(List<Collection> collectionsToCache, String path) async {
    // Example: if path = '/Notes', it will point to collections inside this path
    List<Map<String, dynamic>> collectionsAsMap = [];
    for (var i = 0; i < collectionsToCache.length; i++) {
      collectionsAsMap.add(collectionsToCache[i].toMap());
    }
    await AppVariables.appState.write('collections($path)', collectionsAsMap);
    await AppVariables.appState.write('collections($path){expiryInformation}', {
      'cachedAt': DateTime.now().toIso8601String(),
      'expiresAfter': 60,
    });
  }

  Future<void> notesForPath(List<Note> notesToCache, String path) async {
    // Example: if path = '/Notes', it will point to notes inside this path

    List<Map<String, dynamic>> notesAsMap = [];
    for (var i = 0; i < notesToCache.length; i++) {
      notesAsMap.add(notesToCache[i].toMap());
    }
    await AppVariables.appState.write('notes($path)', notesAsMap);
    await AppVariables.appState.write('notes($path){expiryInformation}', {
      'cachedAt': DateTime.now().toIso8601String(),
      'expiresAfter': 60,
    });
  }
}
