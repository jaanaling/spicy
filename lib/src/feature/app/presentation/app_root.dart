import 'package:flutter/cupertino.dart';
import 'package:application/routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routerConfig: buildGoRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
