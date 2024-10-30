import 'package:application/routes/root_navigation_screen.dart';
import 'package:application/routes/route_value.dart';
import 'package:application/src/feature/challenge/presentation/screens/challenge_screen.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/presentation/screens/main_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/create_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/privicy_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/recipe_screen.dart';
import 'package:application/src/feature/recipe/presentation/screens/recommendation_screen.dart';
import 'package:application/src/feature/splash/presentation/screens/splash_screen.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _createNavigatorKey = GlobalKey<NavigatorState>();
final _challengeNavigatorKey = GlobalKey<NavigatorState>();
final _recommendationNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildGoRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RouteValue.splash.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) {
        return NoTransitionPage(
          child: RootNavigationScreen(
            navigationShell: navigationShell,
            route: state.uri.path,
          ),
        );
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _homeNavigatorKey,
              path: RouteValue.home.path,
              builder: (context, state) => ColoredBox(
                color: Colors.white,
                child: MainScreen(key: UniqueKey()),
              ),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _homeNavigatorKey,
                  path: RouteValue.recipe.path,
                  builder: (context, state) {
                    final extra = state.extra! as RecipeModel;
                    return ColoredBox(
                      color: Colors.white,
                      child: RecipeScreen(
                        key: UniqueKey(),
                        recipe: extra,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _challengeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _challengeNavigatorKey,
              path: RouteValue.challenge.path,
              builder: (context, state) => ColoredBox(
                color: Colors.white,
                child: ChallengeScreen(key: UniqueKey()),
              ),
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _challengeNavigatorKey,
                  path: RouteValue.recipe.path,
                  builder: (context, state) {
                    final extra = state.extra! as RecipeModel;
                    return ColoredBox(
                      color: Colors.white,
                      child: RecipeScreen(
                        key: UniqueKey(),
                        recipe: extra,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _recommendationNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _recommendationNavigatorKey,
              path: RouteValue.recommendation.path,
              builder: (context, state) => ColoredBox(
                color: Colors.white,
                child: RecommendationScreen(key: UniqueKey()),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _createNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              parentNavigatorKey: _createNavigatorKey,
              path: RouteValue.create.path,
              builder: (context, state) => ColoredBox(
                color: Colors.white,
                child: CreateScreen(key: UniqueKey()),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
  parentNavigatorKey: _rootNavigatorKey,
  path: '/core',
  pageBuilder: (context, state) {
    return NoTransitionPage(
      child: CoreScreen(
        key: UniqueKey(),
      ),
    );
  },
),
 GoRoute(
          path: RouteValue.privacyScreen.path,
          pageBuilder: (context, state) => NoTransitionPage(
            child: PrivicyScreen(
              key: UniqueKey(),
            ),
          ),
        ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: CupertinoPageScaffold(
            child: child,
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteValue.splash.path,
          builder: (BuildContext context, GoRouterState state) {
            return SplashScreen(key: UniqueKey());
          },
        ),
      ],
    ),
  ],
);
