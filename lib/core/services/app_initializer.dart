import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorageDirectory, HydratedStorage;
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/utils/constants_manager.dart';
import 'package:math_corn/firebase_options.dart';
import 'package:math_corn/modules/main/ui/screens/main_screen.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:path_provider/path_provider.dart';

import '../../modules/auth/ui/screens/login_screen.dart';
import '../debugging/app_logger.dart';

class AppInitializer {
  static void initializeServiceLocator() {
    ServiceLocator.init();
  }

  static Future<void> initializeHydratedStorage() async {
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory((await getTemporaryDirectory()).path),
    );
  }

  static Future<Widget> init() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    AppLogger.init();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ConstantsManager.packageInfo = await PackageInfo.fromPlatform();
    // SecureStorageHelper.init();
    if (FirebaseAuth.instance.currentUser != null) {
      return MainScreen();
    } else {
      return LoginScreen();
    }
  }

  static Future<void> saveFirstRunFlag() async {}
}
