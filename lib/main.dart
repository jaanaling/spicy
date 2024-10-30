import 'dart:async';
import 'package:application/firebase_options.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/core/dependency_injection.dart';
import 'package:application/src/feature/app/presentation/app_root.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_amplitude/core_amplitude.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
   runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupDependencyInjection();

   await InitializationUtil.coreInit(
    domain: 'spicejourneya.com',
    amplitudeKey: '7cdece7a86d652ff8fac696a89b8deaa',
    appId: 'com.gametrucklls.spicejourney',
    iosAppId: '6737221010',
    initialRoute: RouteValue.home.path,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

     FlutterError.onError = (FlutterErrorDetails details) {
         _handleFlutterError(details);
      };

    runApp(
      const AppRoot(),
    );
   }, (Object error, StackTrace stackTrace) {
      _handleAsyncError(error, stackTrace);
   });
}

void _handleFlutterError(FlutterErrorDetails details) {
   AmplitudeUtil.logFailure(
      details.exception is Exception ? Failure.exception : Failure.error,
      details.exception.toString(),
      details.stack,
   );
}

void _handleAsyncError(Object error, StackTrace stackTrace) {
   AmplitudeUtil.logFailure(
      error is Exception ? Failure.exception : Failure.error,
      error.toString(),
      stackTrace,
   );
}
