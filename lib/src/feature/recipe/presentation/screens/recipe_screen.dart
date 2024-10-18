import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/icon_provider.dart';
import '../../../../ui_kit/app_icon/widget/app_icon.dart';

class RecipeScreen extends StatelessWidget {
  final RecipeModel recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 391,
              decoration: const BoxDecoration(
                color: Color(0xFF9A0A10),
                borderRadius: BorderRadius.only(
                  bottomLeft:
                      Radius.circular(180),
                  bottomRight: Radius.circular(180),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AppIcon(
                asset: recipe.imagePath,
                width: 218,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 72,
              right: 23,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.heart),
                iconSize: 34,
              ),
            ),
            Positioned(
              top: 62,
              left: 15,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.chevron_left_circle_fill),
                iconSize: 55,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w700,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return Visibility(
                  visible: index < recipe.spicinessLevel,
                  child: AppIcon(
                    asset: IconProvider.pepper.buildImageUrl(),
                    width: 22,
                    fit: BoxFit.fitWidth,
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}
