import 'package:app/config/injection.dart';
import 'package:app/utils/app_config.dart';
import 'package:app/utils/environment.constants.dart';
import 'package:app/utils/firebase/firebase_manager.dart';
import 'package:app/utils/firebase/firestore_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application.dart';
import 'config/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  setupDependencyInjection(prefs);

  Environment.initialise(Enviroment.Staging);

  var configuredApp = AppConfig(
    enviroment: Enviroment.Staging,
    child: App(),
  );
  runApp(configuredApp);

  FirebaseManager.getInstance().initialise();
  FirestoreManager.getInstance().initialise();
}
