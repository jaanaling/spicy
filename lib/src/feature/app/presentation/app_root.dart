import 'package:application/src/feature/challenge/bloc/challenge_bloc.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:application/routes/go_router_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RecipeBloc()..add(LoadRecipes()),
        ),
        BlocProvider(
          create: (context) => ChallengeBloc()..add(LoadChallengesEvent()),
        ),
      ],
      child: CupertinoApp.router(
        routerConfig: buildGoRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
