import 'dart:ui';
import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  const BottomBar({super.key, required this.selectedIndex, required this.onTap});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 9),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: const Color(0xFF9A0A10),
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
                      onPressed: () {
                        _onItemTapped(0);
                      },
                    ),
                    _buildIconButton(
                      index: 1,
                      iconUrl: IconProvider.chellenge.buildImageUrl(),
                      iconUrlA: IconProvider.chellenge_a.buildImageUrl(),
                      onPressed: () {
                        _onItemTapped(1);
                      },
                    ),
                    _buildIconButton(
                      index: 2,
                      iconUrl: IconProvider.rec.buildImageUrl(),
                      iconUrlA: IconProvider.rec_a.buildImageUrl(),
                      onPressed: () {
                        _onItemTapped(2);
                      },
                    ),
                    _buildIconButton(
                      index: 3,
                      iconUrl: IconProvider.create.buildImageUrl(),
                      iconUrlA: IconProvider.create_a.buildImageUrl(),
                      onPressed: () {
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
      _controller.forward().then((_) => _controller.reverse());
    });
    widget.onTap(index);
  }

  Widget _buildIconButton({
    required int index,
    required String iconUrl,
    required String iconUrlA,
    required VoidCallback onPressed,
  }) {
    return ScaleTransition(
      scale: _currentIndex == index ? _animation : const AlwaysStoppedAnimation(1.0),
      child: IconButton(
        onPressed: onPressed,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashRadius: 20,
        icon: AppIcon(
          asset: _currentIndex == index ? iconUrlA : iconUrl,
          height: 30,
        ),
      ),
    );
  }
}
