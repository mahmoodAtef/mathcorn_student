import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:math_corn/core/services/app_initializer.dart';
import 'package:math_corn/core/services/dep_injection.dart';
import 'package:math_corn/core/services/localization_manager.dart';
import 'package:math_corn/core/utils/theme_manager.dart';
import 'package:math_corn/modules/settings/cubit/settings_cubit.dart';
import 'package:math_corn/modules/student/cubit/student_cubit.dart';
import 'package:sizer/sizer.dart';

import 'core/widgets/splash_screen.dart';
import 'generated/l10n.dart';
import 'modules/auth/cubit/auth_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppInitializer.initializeServiceLocator();
  await AppInitializer.initializeHydratedStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>(create: (context) => sl()),
            BlocProvider<StudentCubit>(create: (context) => sl()),
            BlocProvider<SettingsCubit>(create: (context) => sl()),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                themeAnimationCurve: Curves.bounceInOut,
                themeAnimationDuration: const Duration(milliseconds: 100),
                title: 'MathCorn',
                theme: AppTheme.currentTheme,
                darkTheme: AppTheme.darkTheme,
                themeAnimationStyle: AnimationStyle(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceInOut,
                ),
                locale: LocalizationManager.getCurrentLocale(),
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                home: const SplashScreenV2(),
              );
            },
          ),
        );
      },
    );
  }
}
