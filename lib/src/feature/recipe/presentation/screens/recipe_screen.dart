import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';

class RecipeScreen extends StatefulWidget {
  final RecipeModel recipe;
  const RecipeScreen({super.key, required this.recipe});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int _servings = 0;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(top: height * 0.448 + 49),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.recipe.name,
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return Visibility(
                          visible: index < widget.recipe.spicinessLevel,
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
                const Gap(14),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    border: Border.all(color: const Color(0xFFDCDCDC)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
                    child: SizedBox(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color(0xFF9A0A10),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (_servings != 1) {
                                  setState(() {
                                    _servings--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                              iconSize: 33,
                            ),
                          ),
                          Text(
                            _servings.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                          DecoratedBox(
                            decoration: const BoxDecoration(
                              color: Color(0xFF9A0A10),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (_servings != 99) {
                                  setState(() {
                                    _servings++;
                                  });
                                }
                              },
                              icon: const Icon(Icons.add),
                              iconSize: 33,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(29),
                const Divider(
                  thickness: 1.5,
                  color: Color(0xFF9A0A10),
                ),
                Gap(6),
              ],
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: double.infinity,
              height: height * 0.448,
              decoration: const BoxDecoration(
                color: Color(0xFF9A0A10),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(180),
                  bottomRight: Radius.circular(180),
                ),
              ),
            ),
            Positioned(
              bottom: -22,
              child: AppIcon(
                asset: widget.recipe.imagePath,
                width: width * 0.747,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 40,
              right: 23,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.heart),
                iconSize: 34,
              ),
            ),
            Positioned(
              top: 30,
              left: 15,
              child: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(CupertinoIcons.chevron_left_circle_fill),
                iconSize: 55,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String name;
  final double count;
  const InfoRow({super.key, required this.name, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
      ],
    );
  }
}
