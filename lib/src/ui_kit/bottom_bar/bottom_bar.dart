import 'dart:ui';
import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:math' as math;

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;
  const BottomBar(
      {super.key, required this.selectedIndex, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentIndex = 0;

  final List<double> _initialAngles = [0, -18, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 9),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: Color(0xFF9A0A10),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 81,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      index: 0,
                      iconUrl: IconProvider.home.buildImageUrl(),
                      iconUrlA: IconProvider.home_a.buildImageUrl(),
                      initialAngle: _initialAngles[0],
                      onPressed: () {
                        context.go(RouteValue.home.path);
                        _onItemTapped(0);
                      },
                    ),
                    _buildIconButton(
                      index: 1,
                      iconUrl: IconProvider.chellenge.buildImageUrl(),
                      iconUrlA: IconProvider.chellenge_a.buildImageUrl(),
                      initialAngle: _initialAngles[1],
                      onPressed: () {
                        context.go(RouteValue.challenge.path);
                        _onItemTapped(1);
                      },
                    ),
                    _buildIconButton(
                      index: 2,
                      iconUrl: IconProvider.rec.buildImageUrl(),
                      iconUrlA: IconProvider.rec_a.buildImageUrl(),
                      initialAngle: _initialAngles[2],
                      onPressed: () {
                        context.go(RouteValue.recommendation.path);
                        _onItemTapped(2);
                      },
                    ),
                    _buildIconButton(
                      index: 3,
                      iconUrl: IconProvider.create.buildImageUrl(),
                      iconUrlA: IconProvider.create_a.buildImageUrl(),
                      initialAngle: _initialAngles[3],
                      onPressed: () {
                        context.go(RouteValue.create.path);
                        _onItemTapped(3);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTap(index);
  }

  Widget _buildIconButton({
    required int index,
    required String iconUrl,
    required String iconUrlA,
    required double initialAngle,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashRadius: 20,
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: _currentIndex == index ? 15 : 0,
            ),
            duration: const Duration(milliseconds: 300),
            builder: (context, angle, child) {
              return Transform.rotate(
                angle: (initialAngle + angle) * math.pi / 180,
                child: child,
              );
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(
                begin: 0,
                end: _currentIndex == index ? -10 : 0,
              ),
              duration: const Duration(milliseconds: 300),
              builder: (context, offset, child) {
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: AppIcon(
                    asset: _currentIndex == index ? iconUrlA : iconUrl,
                    height: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
