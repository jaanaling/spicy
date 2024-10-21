import 'package:application/src/feature/challenge/bloc/challenge_bloc.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/routes/go_router_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: buildGoRouter,
      debugShowCheckedModeBanner: false,
       localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF9A0A10),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'poppins',
            fontWeight: FontWeight.w400,
            fontSize: 21,
          ),
        ),
      ),
    );
  }
}
