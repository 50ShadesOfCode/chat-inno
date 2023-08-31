import 'package:core/core.dart';
import 'package:core/localization/app_localization.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  AppDI.initFirebase();
  await Firebase.initializeApp(
    options: appLocator<FirebaseOptions>(),
  );
  AppDI.initDependencies();

  await dataDI.initDependencies();

  final NotificationSettings notificationSettings =
      await appLocator.get<FirebaseMessaging>().requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

  runApp(
    EasyLocalization(
      supportedLocales: AppLocalization.supportedLocales,
      path: AppLocalization.langsFolderPath,
      fallbackLocale: AppLocalization.fallbackLocale,
      child: const App(),
    ),
  );
}
