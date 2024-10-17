import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppIcon(
          asset: IconProvider.dish_card.buildImageUrl(),
          width: double.infinity,
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
          top: 61,
          right: 0,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Color.fromRGBO(7, 5, 5, 0.53),
                ],
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 33, top: 4, bottom: 4, right: 12),
              child: Row(
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
            ),
          ),
        ),
        Positioned(
          left: 19,
          top: 15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(5),
              Text(
                '~ ${recipe.time}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 6,
          left: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFFAB57),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 22),
              child: Text(recipe.difficulty),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.heart),
            iconSize: 34,
          ),
        ),
      ],
    );
  }
}
