import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:navigation/navigation.dart';

import '../config/firebase_options.dart';

final AppDI appDI = AppDI();
final GetIt appLocator = GetIt.instance;

class AppDI {
  static void initFirebase() {
    appLocator.registerSingleton<FirebaseOptions>(
      DefaultFirebaseOptions.currentPlatform,
    );
  }

  static void initDependencies() {
    appLocator.registerSingleton<AppRouter>(
      AppRouter(),
    );
    appLocator.registerSingleton<FirebaseMessaging>(
      FirebaseMessaging.instance,
    );
  }
}
