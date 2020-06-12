import 'package:app/utils/constants.dart';
import 'package:app/utils/firebase/models/firestore-location.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class FirestoreManager {
  static final FirestoreManager _singleton = FirestoreManager._internal();
  final String databaseName = 'locations';

  factory FirestoreManager() {
    return _singleton;
  }

  FirestoreManager._internal();

  static getInstance() {
    return _singleton;
  }

  Firestore firestore;
  CollectionReference locations;

  Future<void> initialise() async {
    final FirebaseApp app = defaultTargetPlatform == TargetPlatform.android
        ? await FirebaseApp.configure(
            name: kFirebaseProjectName,
            options: const FirebaseOptions(
              googleAppID: kFirebaseAppIdAndroid,
              gcmSenderID: kFirebaseGcmSenderId,
              apiKey: kGoogleKeyAndroid,
              projectID: kFirebaseProjectId,
            ),
          )
        : await FirebaseApp.configure(
            name: kFirebaseProjectName,
            options: const FirebaseOptions(
              googleAppID: kFirebaseAppIdiOS,
              gcmSenderID: kFirebaseGcmSenderId,
              apiKey: kGoogleKeyiOS,
              projectID: kFirebaseProjectId,
            ),
          );

    final _auth = FirebaseAuth.fromApp(app);
    await _auth.signInAnonymously();

    firestore = Firestore(app: app);
    locations = firestore.collection(databaseName);
  }

  Future<void> writeLocation(Map<String, dynamic> location) async {
    final batchWrite = firestore.batch();
    batchWrite.setData(locations.document(), location);
    await batchWrite.commit();
  }

  getLocation(int appointmentId, int providerId,
      Function providerLocationChanged) async {
    Query query = locations
//        .where('provider_id', isEqualTo: providerId)
//        .where('appointment_id', isEqualTo: appointmentId)
        .limit(1);

    query.snapshots().listen((data) {
      if (data.documents.length > 0) {
        providerLocationChanged(
            FirestoreLocation.fromJson(data.documents.last.data));
      }
    });
  }
}
