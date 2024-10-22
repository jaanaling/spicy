import 'dart:math';

import 'package:application/routes/route_value.dart';
import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/ui_kit/app_icon/widget/app_icon.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:gap/gap.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/presentation/widgets/recipe_card.dart';
import 'package:go_router/go_router.dart';
import 'package:application/src/ui_kit/custom_decoration.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchController = TextEditingController();
  double sliderValue = 3;
  List<String> difficulty = ['Easy', 'Medium', 'Hard'];
  String? cuisine;
  int selectedIndexCountry = 0;
  int selectedIndexTime = 0;
  String? selectedTime;
  final CarouselSliderController _pageController = CarouselSliderController();
  int _currentPage = 0;
  List<RecipeModel> recipes = [];

  List<String> countries = [
    'China',
    'India',
    'South Korea',
    'Vietnam',
    'Thailand',
    'Malaysia',
    'All Countries',
  ];

  String getShortCountryName(String country) {
    switch (country.toLowerCase()) {
      case 'china':
        return 'CN';
      case 'india':
        return 'IN';
      case 'south korea':
        return 'KR';
      case 'vietnam':
        return 'VN';
      case 'thailand':
        return 'TH';
      case 'malaysia':
        return 'MY';
      default:
        throw Exception('Short country name not found $country');
    }
  }

  List<String> timeRanges = [
    'From 0 to 30 minutes',
    'From 30 minutes to an hour',
    'More than an hour',
    'None',
  ];

  int _convertTimeToMinutes(String time) {
    if (time.contains('min')) {
      return int.parse(time.split(' ')[0]); // возвращает число минут
    } else if (time.contains('h')) {
      return int.parse(time.split(' ')[0]) * 60; // переводит часы в минуты
    } else if (time.contains('day')) {
      return int.parse(time.split(' ')[0]) * 1440; // переводит дни в минуты
    }
    return 0; // если время не соответствует, возвращает 0
  }

  AppIcon getCountryIcon(String country) {
    switch (country.toLowerCase()) {
      case 'china':
        return AppIcon(asset: IconProvider.china.buildImageUrl());
      case 'india':
        return AppIcon(asset: IconProvider.india.buildImageUrl());
      case 'south korea':
        return AppIcon(asset: IconProvider.south_korea.buildImageUrl());
      case 'vietnam':
        return AppIcon(asset: IconProvider.vietnam.buildImageUrl());
      case 'thailand':
        return AppIcon(asset: IconProvider.thailand.buildImageUrl());
      case 'malaysia':
        return AppIcon(asset: IconProvider.malaysia.buildImageUrl());
      default:
        throw Exception('Country icon not found $country');
    }
  }

  void _showCountrySnackBar(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return ColoredBox(
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

                      if (selectedIndexCountry == 6) {
                        cuisine = null;
                      } else {
                        cuisine = countries[selectedIndexCountry];
                      }
                    });
                  },
                  children: countries.map((String country) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.28,
                      ),
                      child: Row(
                        children: [
                          if (country != countries[6]) getCountryIcon(country),
                          const Gap(16),
                          Text(country),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              CupertinoButton(
                child: const Text(
                  'Done',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
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
        return ColoredBox(
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
                      if (selectedIndexTime == 0) {
                        selectedTime = '<30 min';
                      } else if (selectedIndexTime == 1) {
                        selectedTime = '30-60 min';
                      } else if (selectedIndexTime == 2) {
                        selectedTime = '> 1 hr';
                      } else {
                        selectedTime = null;
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
                child: const Text(
                  'Done',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
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
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state is RecipeLoaded) {
          recipes = state.recipes.where((recipe) {
            if (cuisine != null) {
              return recipe.cuisine == cuisine;
            }
            return true;
          }).where((recipe) {
            return recipe.spicinessLevel == sliderValue;
          }).where((recipe) {
            if (difficulty.isNotEmpty) {
              return difficulty.contains(recipe.difficulty);
            }
            return true;
          }).where((recipe) {
            if (selectedTime != null) {
              int cookingTimeInMinutes = _convertTimeToMinutes(recipe.time);
              switch (selectedTime) {
                case '<30 min':
                  return cookingTimeInMinutes <= 30;
                case '30-60 min':
                  return cookingTimeInMinutes > 30 &&
                      cookingTimeInMinutes <= 60;
                case '> 1hr':
                  return cookingTimeInMinutes > 60;
                default:
                  return true;
              }
            }
            return true;
          }).where((recipe) {
            if (searchController.text.isNotEmpty) {
              return recipe.name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
            }
            return true;
          }).toList();
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 110),
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: CupertinoTextField(
                      controller: searchController,
                      onTapOutside: (event) {
                        setState(() {});
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        setState(() {});
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
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
                      onChanged: (value) {
                        setState(() {});
                      },
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Stack(
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
                  ),
                  const Gap(13),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        difficultyButton('Easy', const Color(0xFFA6FE7E)),
                        difficultyButton('Medium', const Color(0xFFFFAB57)),
                        difficultyButton('Hard', const Color(0xFFFF5B62)),
                      ],
                    ),
                  ),
                  const Gap(17),
                  Padding(
                    padding: const EdgeInsets.only(left: 21),
                    child: Row(
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
                                    if (cuisine != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 25,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: getCountryIcon(
                                                cuisine ?? '',
                                              ),
                                            ),
                                          ),
                                          const Gap(8),
                                          Text(
                                            getShortCountryName(cuisine ?? ''),
                                            style: const TextStyle(
                                              fontSize: 21,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      const Text(
                                        'Country',
                                        style: TextStyle(
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
                        Padding(
                          padding: const EdgeInsets.only(right: 21),
                          child: GestureDetector(
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
                                        selectedTime != null
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
                        ),
                      ],
                    ),
                  ),
                  const Gap(33),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 21),
                    child: const Divider(
                      thickness: 1.5,
                      color: Color(0xFF9A0A10),
                    ),
                  ),
                  const Gap(24),
                  if (recipes.isEmpty)
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
                          itemBuilder: (BuildContext context, int index,
                              int pageViewIndex,) {
                            final recipe = recipes[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.007),
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
                              onPageChanged: (int index,
                                  CarouselPageChangedReason reason) {
                                setState(() {
                                  _currentPage = index;
                                });
                              }),
                        ),
                        if (_currentPage > 0)
                          Positioned(
                            left: 11.0,
                            child: IconButton(
                              icon: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(pi),
                                child: AppIcon(
                                    asset: IconProvider.arrowNext
                                        .buildImageUrl()),
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
                                  asset:
                                      IconProvider.arrowNext.buildImageUrl()),
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
              ),
            ),
          );
        } else {
          return const Center(child: CupertinoActivityIndicator());
        }
      },
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
            if (difficulty.contains(difficultyName)) {
              if (difficulty.length > 1) {
                difficulty.remove(difficultyName);
              }
            } else {
              difficulty.add(difficultyName);
            }
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
  final double? levelDouble = double.tryParse(levelStr);
  if (levelDouble == null) {
    return 'Unknown level';
  }

  final int level = levelDouble.toInt();

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
