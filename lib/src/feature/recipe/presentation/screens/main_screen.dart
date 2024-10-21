import 'dart:ui';
import 'dart:ui';

import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:gap/gap.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/presentation/widgets/recipe_card.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui_kit/custom_decoration.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchController = TextEditingController();
  double sliderValue = 1;
  List<String> difficulty = ['Easy', 'Medium', 'Hard'];
  String? cuisine;
  int selectedIndexCountry = 0;
  int selectedIndexTime = 0;
  String? selectedTime;

  List<String> countries = [
    'China',
    'India',
    'South Korea',
    'Vietnam',
    'Thailand',
    'Malaysia',
  ];

  List<String> timeRanges = [
    'From 0 to 30 minutes',
    'From 30 minutes to an hour',
    'More than an hour',
  ];

  void _showCountrySnackBar(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: CupertinoColors.systemBackground,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Country',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndexCountry,
                  ),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndexCountry = index;
                      cuisine = countries[selectedIndexCountry];
                    });
                  },
                  children: countries.map((String country) {
                    return Center(
                      child: Text(country),
                    );
                  }).toList(),
                ),
              ),
              CupertinoButton(
                child: const Text('Done',   style: TextStyle(color: CupertinoColors.activeBlue),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTimePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: CupertinoColors.systemBackground,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedIndexTime,
                  ),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndexTime = index;
                      if(selectedIndexTime == 0){
                        selectedTime = '<30 min';
                      }
                      else if (selectedIndexTime == 1){
                        selectedTime = '30-60 min';
                      }
                      else if (selectedIndexTime == 2){
                        selectedTime = '> 1 hr';
                      }
                    });
                  },
                  children: timeRanges.map((String country) {
                    return Center(
                      child: Text(country),
                    );
                  }).toList(),
                ),
              ),
              CupertinoButton(
                child: const Text('Done',   style: TextStyle(color: CupertinoColors.activeBlue),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => RecipeBloc()..add(LoadRecipes()),
      child: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is RecipeLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21, top: 31),
                child: Column(
                  children: [
                    CupertinoTextField(
                      controller: searchController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      padding: const EdgeInsets.all(17),
                      placeholder: 'Enter text...',
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 17),
                        child: AppIcon(
                          asset: IconProvider.search.buildImageUrl(),
                        ),
                      ),
                      placeholderStyle: const TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFA5A5A5),
                      ),
                      style: const TextStyle(
                        fontSize: 27,
                        color: CupertinoColors.black,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD0D0D0)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.1),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: FlutterSlider(
                            min: 1,
                            max: 5,
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              sliderValue = lowerValue as double;
                              setState(() {});
                            },
                            tooltip: FlutterSliderTooltip(
                              format: getSpiceLevel,
                            ),
                            trackBar: FlutterSliderTrackBar(
                              activeTrackBar: BoxDecoration(
                                color: const Color(0xFF9A0A10),
                                borderRadius: BorderRadius.circular(23),
                              ),
                              activeTrackBarHeight: 4,
                              inactiveTrackBarHeight: 4,
                              inactiveTrackBar: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(23),
                              ),
                            ),
                            handler: FlutterSliderHandler(
                              decoration: const BoxDecoration(),
                              child: Material(
                                color: Colors.transparent,
                                child: AppIcon(
                                  asset: IconProvider.pepper.buildImageUrl(),
                                ),
                              ),
                            ),
                            values: [sliderValue],
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          left: 5,
                          child: Text(
                            '1',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          right: 5,
                          child: Text(
                            '5',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const Gap(13),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        difficultyButton('Easy', const Color(0xFFA6FE7E)),
                        difficultyButton('Medium', const Color(0xFFFFAB57)),
                        difficultyButton('Hard', const Color(0xFFFF5B62)),
                      ],
                    ),
                    const Gap(17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showCountrySnackBar(context);
                          },
                          child: DecoratedBox(
                            decoration: customDecoration(),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * 0.233,
                                      height: 27,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          cuisine ?? 'Country',
                                          style: const TextStyle(
                                            fontSize: 21,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    AppIcon(
                                      asset: IconProvider.chevronDown
                                          .buildImageUrl(),
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.51),
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showTimePicker(context);
                          },
                          child: DecoratedBox(
                            decoration: customDecoration(),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.43,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedTime!=null
                                          ? selectedTime ?? ''
                                          : 'Time',
                                      style: const TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                      ),
                                    ),
                                    AppIcon(
                                      asset: IconProvider.chevronDown
                                          .buildImageUrl(),
                                      color: const Color.fromARGB(255, 0, 0, 0)
                                          .withOpacity(0.51),
                                      width: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(33),
                    const Divider(
                      thickness: 1.5,
                      color: Color(0xFF9A0A10),
                    ),
                    const Gap(24),
                    SizedBox(
                      width: width * 0.71,
                      height: height * 0.381,
                      child: PageView.builder(
                        itemCount: state.recipes.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final recipe = state.recipes[index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '${RouteValue.home.path}/${RouteValue.recipe.path}',
                                extra: recipe,
                              );
                            },
                            child: RecipeCard(
                              recipe: recipe,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Widget difficultyButton(String difficultyName, Color color) {
    final width = MediaQuery.of(context).size.width;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(12),
      onPressed: () {
        setState(() {
          setState(() {
            difficulty.contains(difficultyName)
                ? difficulty.remove(difficultyName)
                : difficulty.add(difficultyName);
          });
        });
      },
      color:
          difficulty.contains(difficultyName) ? color : const Color(0xFFB9B9B9),
      child: SizedBox(
        width: width * 0.286,
        child: Center(
          child: Text(
            difficultyName.toLowerCase(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

String getSpiceLevel(String levelStr) {
  double? levelDouble = double.tryParse(levelStr);
  if (levelDouble == null) {
    return 'Unknown level';
  }

  int level = levelDouble.toInt();

  switch (level) {
    case 1:
      return 'Mild';
    case 2:
      return 'Medium';
    case 3:
      return 'Spicy';
    case 4:
      return 'Hot';
    case 5:
      return 'Very Hot';
    default:
      return 'Unknown level';
  }
}
