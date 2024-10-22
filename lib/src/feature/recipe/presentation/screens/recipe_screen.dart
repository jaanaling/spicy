import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isStepByStepEnabled = false;
  bool isNextStepVisible = false;
  bool isFavorite = false;
  final CarouselSliderController _pageController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
    isFavorite =
                                widget.recipe.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 110),
      child: Column(
        children: [
          Column(
            children: [
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
                    bottom: 0,
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
                      onPressed: () {
                        setState(() {
                           context
                            .read<RecipeBloc>()
                            .add(ToggleFavorite(widget.recipe.name));
                         isFavorite = !isFavorite;
                          
                        });
                       
                      },
                      icon: Icon(
                        isFavorite
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Colors.white,
                      ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.recipe.name,
                            style: const TextStyle(
                              fontSize: 29,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 8),
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
                    const Gap(15),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NutrientInput(
                          label: 'Calories',
                          icon: SvgPicture.asset(
                            IconProvider.calories.buildImageUrl(),
                          ),
                          count: widget.recipe.calories * _servings,
                        ),
                        const Gap(5),
                        NutrientInput(
                          label: 'proteins',
                          count: widget.recipe.proteins * _servings,
                        ),
                        const Gap(5),
                        NutrientInput(
                          label: 'fats',
                          count: widget.recipe.fats * _servings,
                        ),
                        const Gap(5),
                        NutrientInput(
                          label: 'carbohydrates',
                          count: widget.recipe.carbs * _servings,
                        ),
                      ],
                    ),
                    const Gap(26),
                    const Divider(
                      thickness: 1.5,
                      color: Color(0xFF9A0A10),
                    ),
                    const Gap(17),
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    ListView.separated(
                      itemCount: widget.recipe.ingredients.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Gap(12),
                      itemBuilder: (context, index) {
                        return IngredientInput(
                          label: widget.recipe.ingredients[index].name,
                          count: widget.recipe.ingredients[index].quantity
                                  .ceilToDouble() *
                              _servings,
                          countType:
                              widget.recipe.ingredients[index].quantityType,
                        );
                      },
                    ),
                    const Gap(25),
                    const Divider(
                      thickness: 1.5,
                      color: Color(0xFF9A0A10),
                    ),
                    const Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recipe',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isStepByStepEnabled = !isStepByStepEnabled;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AppIcon(
                                  asset: IconProvider.button.buildImageUrl()),
                              Text(
                                isStepByStepEnabled
                                    ? 'Full Recipe'
                                    : 'Step-by-Step',
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    Text(
                      widget.recipe.description,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    const Gap(12),
                    if (isStepByStepEnabled)
                      CarouselSlider.builder(
                        carouselController: _pageController,
                        itemCount: widget.recipe.steps.length,
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 305 + 110,
                          enableInfiniteScroll: false,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                        ),
                        itemBuilder: (
                          BuildContext context,
                          int index,
                          int pageViewIndex,
                        ) {
                          final step = widget.recipe.steps[index];
                          return Column(
                            children: [
                              StepCard(
                                step: step,
                                index: index,
                                isCheckBoxVisible:
                                    index + 1 != widget.recipe.steps.length,
                                onChanged: (value) {
                                  setState(() {
                                    isNextStepVisible = value ?? false;
                                  });
                                },
                              ),
                              Visibility(
                                visible: isNextStepVisible,
                                child: GestureDetector(
                                  onTap: () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {
                                      isNextStepVisible = false;
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      AppIcon(
                                        asset:
                                            IconProvider.button.buildImageUrl(),
                                      ),
                                      const Text(
                                        'next step',
                                        style: TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    else
                      ListView.separated(
                        itemCount: widget.recipe.steps.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) =>
                            const Gap(12),
                        itemBuilder: (context, index) {
                          final step = widget.recipe.steps[index];
                          return StepInfo(step: step, index: index);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
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
        Gap(6),
        Expanded(
          child: Text(
            count.toString(),
            style: const TextStyle(fontSize: 17, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class NutrientInput extends StatelessWidget {
  final String label;
  final double count;
  final Widget? icon;

  const NutrientInput({
    super.key,
    required this.label,
    required this.count,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) icon!,
            Padding(
              padding: EdgeInsets.only(left: icon == null ? 19 : 3),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: icon == null ? 17 : 21,
                  fontWeight: icon == null ? FontWeight.w400 : FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
            ),
          ],
        ),
        Gap(6),
        Expanded(
          child: Text(
            formatCount(count),
            style: TextStyle(
              fontSize: icon == null ? 17 : 21,
              fontWeight: icon == null ? FontWeight.w400 : FontWeight.w500,
              color: Colors.black,
              fontFamily: 'poppins',
            ),
          ),
        ),
      ],
    );
  }
}

class IngredientInput extends StatelessWidget {
  final String label;
  final double count;
  final String countType;

  const IngredientInput({
    super.key,
    required this.label,
    required this.count,
    required this.countType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gap(6),
        Text(
          '${formatCount(count)} $countType',
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'poppins',
          ),
        ),
      ],
    );
  }
}

String formatCount(double count) {
  // Проверяем, является ли число целым
  if (count == count.toInt()) {
    // Форматируем целое число с пробелами
    return count.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[0]} ',
        );
  } else {
    // Форматируем дробное число
    final String intPart = count.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[0]} ',
        );
    final String decimalPart = (count - count.toInt())
        .toStringAsFixed(2)
        .substring(2); // Получаем дробную часть
    return '$intPart.$decimalPart'; // Возвращаем целую и дробную части
  }
}

class StepInfo extends StatelessWidget {
  final String step;
  final int index;

  const StepInfo({super.key, required this.step, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              (index + 1).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontFamily: 'poppins',
              ),
            ),
          ),
        ),
        const Gap(8),
        Expanded(
            child: Text(step,
                style: const TextStyle(
                  color: Colors.black,
                ))),
      ],
    );
  }
}

class StepCard extends StatefulWidget {
  final String step;
  final int index;
  final bool isCheckBoxVisible;

  final void Function(bool?) onChanged;

  const StepCard(
      {super.key,
      required this.step,
      required this.index,
      required this.onChanged,
      this.isCheckBoxVisible = true});

  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: AppIcon(
              width: width * 0.71,
              height: 305,
              fit: BoxFit.contain,
              asset: IconProvider.dish_card.buildImageUrl(),
            ),
          ),
          Positioned(
            top: -24,
            left: -24,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
              ),
              child: SizedBox(
                width: 69,
                height: 69,
                child: Center(
                  child: Text(
                    (widget.index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'poppins',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.isCheckBoxVisible,
            child: Positioned(
              right: 5,
              bottom: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'mark as done',
                    style: TextStyle(
                      color: Color(
                        0x54000000,
                      ),
                    ),
                  ),
                  const Gap(7),
                  SizedBox(
                    width: 47,
                    height: 47,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CupertinoCheckbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                          widget.onChanged(value ?? false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            top: 0,
            child: Padding(
              padding: EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
                bottom: widget.isCheckBoxVisible ? 60 : 15,
              ),
              child: SingleChildScrollView(child: Text(widget.step)),
            ),
          ),
        ],
      ),
    );
  }
}
