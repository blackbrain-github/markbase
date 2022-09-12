import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class StringConstants {
  static const String usersCollectionRef = "users";
  static const String notesCollectionRef = "notes";
  static const String collectionCollectionRef = "collections";
}

class FirebaseConstants {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseFunctions functions = FirebaseFunctions.instance;
  static final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
}
