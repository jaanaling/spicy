import 'dart:math';

import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/feature/recipe/repository/repository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:application/src/core/dependency_injection.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:application/src/ui_kit/custom_decoration.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:application/routes/route_value.dart';
import 'package:application/src/feature/recipe/presentation/widgets/recipe_card.dart';

List<Ingredient> selectedMeat = [];
List<Ingredient> selectedVegetables = [];
List<Ingredient> selectedSpices = [];
List<Ingredient> selectedOther = [];

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

enum ProductType {
  meat('Meat'),
  vegetables('Vegetables'),
  spices('Spices'),
  other('Other');

  final String name;

  const ProductType(this.name);
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<RecipeModel> recipes = [];
  final CarouselSliderController _pageController = CarouselSliderController();
  int _currentPage = 0;

  Future<void> _showProductSnackBar(
    BuildContext context,
    ProductType product,
  ) async {
    final List<Ingredient> items =
        locator<RecipeRepository>().getIngredientsByType(product.name);

    final List<bool> selectedState = List<bool>.filled(items.length, false);
    List<Ingredient> currentSelectedItems;

    switch (product) {
      case ProductType.meat:
        currentSelectedItems = selectedMeat;
      case ProductType.vegetables:
        currentSelectedItems = selectedVegetables;
      case ProductType.spices:
        currentSelectedItems = selectedSpices;
      case ProductType.other:
        currentSelectedItems = selectedOther;
    }

    for (final item in currentSelectedItems) {
      final index = items.indexOf(item);
      if (index != -1) {
        selectedState[index] = true;
      }
    }

    final List<Ingredient> selectedItems = await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ColoredBox(
                  color: CupertinoColors.systemBackground,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Select ${product.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return CupertinoButton(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 10,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedState[index] = !selectedState[
                                      index]; // Переключаем состояние выбора
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    selectedState[index]
                                        ? CupertinoIcons
                                            .check_mark_circled_solid
                                        : CupertinoIcons.circle,
                                    color: selectedState[index]
                                        ? CupertinoColors.activeBlue
                                        : CupertinoColors.systemGrey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      items[index].name,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      CupertinoButton(
                        child: const Text(
                          'Done',
                          style: TextStyle(color: CupertinoColors.activeBlue),
                        ),
                        onPressed: () {
                          final List<Ingredient> selectedIngredients = [];
                          for (int i = 0; i < items.length; i++) {
                            if (selectedState[i]) {
                              selectedIngredients.add(items[i]);
                            }
                          }
                          Navigator.pop(context, selectedIngredients);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ) ??
        [];

    setState(() {
      switch (product) {
        case ProductType.meat:
          selectedMeat = selectedItems;
        case ProductType.vegetables:
          selectedVegetables = selectedItems;
        case ProductType.spices:
          selectedSpices = selectedItems;
        case ProductType.other:
          selectedOther = selectedItems;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          recipes = state.recipes.where((recipe) {
            final bool hasMeat = selectedMeat.isNotEmpty &&
                selectedMeat.any(
                  (meat) => recipe.ingredients
                      .any((ingredient) => ingredient.name == meat.name),
                );
            final bool hasVegetables = selectedVegetables.isNotEmpty &&
                selectedVegetables.any(
                  (vegetable) => recipe.ingredients
                      .any((ingredient) => ingredient.name == vegetable.name),
                );
            final bool hasSpices = selectedSpices.isNotEmpty &&
                selectedSpices.any(
                  (spice) => recipe.ingredients
                      .any((ingredient) => ingredient.name == spice.name),
                );
            final bool hasOther = selectedOther.isNotEmpty &&
                selectedOther.any(
                  (other) => recipe.ingredients
                      .any((ingredient) => ingredient.name == other.name),
                );

            return selectedMeat.isNotEmpty ||
                    selectedVegetables.isNotEmpty ||
                    selectedSpices.isNotEmpty ||
                    selectedOther.isNotEmpty
                ? hasMeat || hasVegetables || hasSpices || hasOther
                : false;
          }).toList();
          return Column(
            children: [
              const Gap(16),
              ProductTypeSelector(
                onTap: () {
                  _showProductSnackBar(context, ProductType.meat);
                },
                title: 'Meat',
                iconAsset: IconProvider.meat.buildImageUrl(),
              ),
              const Gap(9),
              ProductTypeSelector(
                onTap: () {
                  _showProductSnackBar(context, ProductType.vegetables);
                },
                title: 'Vegetables',
                iconAsset: IconProvider.veg.buildImageUrl(),
              ),
              const Gap(9),
              ProductTypeSelector(
                onTap: () {
                  _showProductSnackBar(context, ProductType.spices);
                },
                title: 'Spices',
                iconAsset: IconProvider.spices.buildImageUrl(),
              ),
              const Gap(9),
              ProductTypeSelector(
                onTap: () {
                  _showProductSnackBar(context, ProductType.other);
                },
                title: 'Other',
                iconAsset: '',
                icon: const Icon(
                  CupertinoIcons.info,
                  size: 30,
                  color: Colors.grey,
                ),
              ),
              const Gap(46),
              if (selectedMeat.isEmpty &&
                  selectedVegetables.isEmpty &&
                  selectedSpices.isEmpty &&
                  selectedOther.isEmpty)
                const Center(
                  child: Text(
                    'No filters selected.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                )
              else if (recipes.isEmpty)
                const Center(
                  child: Text(
                    'No items found.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                )
              else
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider.builder(
                      carouselController: _pageController,
                      itemCount: recipes.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                        int pageViewIndex,
                      ) {
                        final recipe = recipes[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.007,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              context.push(
                                '${RouteValue.home.path}/${RouteValue.recipe.path}',
                                extra: recipe,
                              );
                            },
                            child: RecipeCard(
                              recipe: recipe,
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: height * 0.381,
                        initialPage: _currentPage,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged:
                            (int index, CarouselPageChangedReason reason) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                      ),
                    ),
                    if (_currentPage > 0)
                      Positioned(
                        left: 11.0,
                        child: IconButton(
                          icon: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: AppIcon(
                              asset: IconProvider.arrowNext.buildImageUrl(),
                            ),
                          ),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                    if (_currentPage < recipes.length - 1)
                      Positioned(
                        right: 11.0,
                        child: IconButton(
                          icon: AppIcon(
                            asset: IconProvider.arrowNext.buildImageUrl(),
                          ),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ),
                  ],
                ),
            ],
          );
        } else {
          return const CupertinoActivityIndicator();
        }
      },
    );
  }
}

class ProductTypeSelector extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String iconAsset;
  final Icon? icon;

  const ProductTypeSelector({
    super.key,
    required this.onTap,
    required this.title,
    required this.iconAsset,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: customDecoration(),
        child: SizedBox(
          height: 62,
          width: MediaQuery.of(context).size.width * 0.669,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 43,
                      child: icon == null
                          ? AppIcon(
                              asset: iconAsset,
                            )
                          : icon!,
                    ),
                    const Gap(4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                AppIcon(
                  asset: IconProvider.chevronDown.buildImageUrl(),
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.51),
                  width: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
