import 'package:application/routes/route_value.dart';
import 'package:application/src/ui_kit/bottom_bar/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class RootNavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String route;

  const RootNavigationScreen({
    super.key,
    required this.navigationShell,
    required this.route,
  });

  @override
  State<RootNavigationScreen> createState() => _RootNavigationScreenState();
}

class _RootNavigationScreenState extends State<RootNavigationScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          SafeArea(top: widget.route != '${RouteValue.home.path}/${RouteValue.recipe.path}', child: widget.navigationShell),
          Positioned(bottom: 0, left: 0, right: 0, child: BottomBar(selectedIndex: currentIndex, onTap: _onTap)),
        ],
      ),
    );
  }

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
    });
    widget.navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }
}
