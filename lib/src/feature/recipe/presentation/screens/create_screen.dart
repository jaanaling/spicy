import 'dart:io';

import 'package:application/src/core/utils/icon_provider.dart';
import 'package:application/src/feature/recipe/bloc/recipe_bloc.dart';
import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/ui_kit/custom_decoration.dart';
import 'package:application/src/ui_kit/plus_button.dart';
import 'package:application/src/ui_kit/raiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../ui_kit/app_icon/widget/app_icon.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final ImagePicker _picker = ImagePicker();

  List<String> countries = [
    'China',
    'India',
    'South Korea',
    'Vietnam',
    'Thailand',
    'Malaysia',
  ];

  List<String> difficulties = [
    'Easy',
    'Medium',
    'Hard',
  ];

  final List<String> units = ['g', 'kg', 'l', 'ml'];
  final List<String> types = ['Vegetables', 'Meat', 'Spices', 'Other'];

  List<int> hours = List<int>.generate(24, (index) => index);
  List<int> minutes = List<int>.generate(60, (index) => index);

  int selectedIndex = 0;
  int selectedDifficultyIndex = 0;
  String selectedUnit = 'g';
  String selectedType = 'Vegetables';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController carbsController = TextEditingController();
  TextEditingController ingredientController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController stepController = TextEditingController();

  File? _image;
  String? difficulty;
  String? cuisine;
  int spicinessLevel = 1;
  int selectedHour = 0;
  int selectedMinute = 0;
  int _rating = 0;

  List<Ingredient> ingredients = [];
  List<String> steps = [];

  bool isStep = false;
  bool isIngredient = false;

  void _showDifficultySnackBar(BuildContext context) {
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
                  'Select Difficulty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: selectedDifficultyIndex,
                  ),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedDifficultyIndex = index;
                      difficulty = difficulties[selectedDifficultyIndex];
                    });
                  },
                  children: difficulties.map((String difficulty) {
                    return Center(
                      child: Text(difficulty),
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
                    initialItem: selectedIndex,
                  ),
                  itemExtent: 32.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedIndex = index;
                      cuisine = countries[selectedIndex];
                    });
                  },
                  children: countries.map((String country) {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.28,
                      ),
                      child: Row(
                        children: [
                          getCountryIcon(country),
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

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedHour,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedHour = index;
                          });
                        },
                        children: hours.map((int hour) {
                          return Center(
                            child: Text(hour.toString().padLeft(2, '0')),
                          );
                        }).toList(),
                      ),
                    ),
                    const Text(':', style: TextStyle(fontSize: 32)),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedMinute,
                        ),
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            selectedMinute = index;
                          });
                        },
                        children: minutes.map((int minute) {
                          return Center(
                            child: Text(minute.toString().padLeft(2, '0')),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: titleController,
            placeholder: 'Enter title...',
            isSuffix: true,
          ),
          const Gap(13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _pickImageFromGallery();
                },
                child: SizedBox(
                  width: 145,
                  height: 145,
                  child: Stack(
                    children: [
                      if (_image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _image!,
                            width: 142,
                            height: 142,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        SvgPicture.asset(
                          IconProvider.no_photo.buildImageUrl(),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: PlusButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showCountrySnackBar(context);
                    },
                    child: DecoratedBox(
                      decoration: customDecoration(),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cuisine ?? 'Country',
                                style: const TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              AppIcon(
                                asset:
                                    IconProvider.chevronDown.buildImageUrl(),
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
                  const Gap(8),
                  GestureDetector(
                    onTap: () {
                      _showTimePicker(context);
                    },
                    child: DecoratedBox(
                      decoration: customDecoration(),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedHour + selectedMinute != 0
                                    ? '$selectedHour:$selectedMinute'
                                    : 'Time',
                                style: const TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontFamily: 'poppins',
                                ),
                              ),
                              AppIcon(
                                asset:
                                    IconProvider.chevronDown.buildImageUrl(),
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
                  const Gap(11),
                  Rating(rating: _rating, onRatingChanged: _onRatingChanged),
                ],
              ),
            ],
          ),
          const Gap(14),
          CustomTextField(
            controller: descriptionController,
            placeholder: 'Enter description...',
            maxLength: 10,
          ),
          const Gap(19),
          GestureDetector(
            onTap: () {
              _showDifficultySnackBar(context);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF9A0A10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      difficulty ?? 'difficulty',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'poppins',
                      ),
                    ),
                    const Gap(6),
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.51),
                      size: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(18),
          const Divider(
            color: Color(0xFF9A0A10),
            thickness: 3,
            height: 3,
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
              PlusButton(
                onPressed: () {
                  setState(() {
                    isIngredient = true;
                  });
                },
              ),
            ],
          ),
          const Gap(15),
          Column(
            children: List.generate(
              ingredients.length,
              (int index) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ingredients[index].name,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontFamily: 'poppins',
                              ),
                            ),
                            Text(
                              '${ingredients[index].quantity} ${ingredients[index].quantityType}',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Text(
                          'Type: ${ingredients[index].type}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  PlusButton(
                    isPlus: false,
                    onPressed: () {
                      setState(() {
                        ingredients.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isIngredient)
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: ingredientController,
                              placeholder: 'ingredient...',
                              fontSize: 14,
                            ),
                          ),
                          const Gap(10),
                          Material(
                            color: Colors.transparent,
                            child: DecoratedBox(
                              decoration: customDecoration(),
                              child: DropdownButton<String>(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.black,
                                  fontFamily: 'poppins',
                                ),
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    CupertinoIcons.chevron_down,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.51),
                                  ),
                                ),
                                iconSize: 16,
                                underline: const SizedBox(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 2,
                                ),
                                value: selectedType,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedType = newValue!;
                                  });
                                },
                                items: types.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: quantityController,
                              placeholder: 'quantity...',
                              fontSize: 14,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          const Gap(10),
                          Material(
                            color: Colors.transparent,
                            child: DecoratedBox(
                              decoration: customDecoration(),
                              child: DropdownButton<String>(
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: CupertinoColors.black,
                                  fontFamily: 'poppins',
                                ),
                                icon: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Icon(
                                    CupertinoIcons.chevron_down,
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.51),
                                  ),
                                ),
                                iconSize: 16,
                                underline: const SizedBox(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 2,
                                ),
                                value: selectedUnit,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedUnit = newValue!;
                                  });
                                },
                                items: units.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(25),
                    ],
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isIngredient = false;
                      ingredients.add(
                        Ingredient(
                          name: ingredientController.text,
                          quantity: int.parse(quantityController.text),
                          quantityType: selectedUnit,
                          type: selectedType,
                        ),
                      );
                      ingredientController.text = '';
                      quantityController.text = '';
                      selectedUnit = 'g';
                      selectedType = 'Meat';
                    });
                  },
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9A0A10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        CupertinoIcons.check_mark,
                        size: 15.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const Gap(15),
          const Divider(
            color: Color(0xFF9A0A10),
            thickness: 3,
            height: 3,
          ),
          const Gap(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step by step recipe',
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'poppins',
                ),
              ),
              PlusButton(
                onPressed: () => setState(() => isStep = true),
              ),
            ],
          ),
          const Gap(15),
          Column(
            children: List.generate(
              steps.length,
              (int index) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ),
                  const Gap(10),
                  PlusButton(
                    isPlus: false,
                    onPressed: () {
                      setState(() {
                        ingredients.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isStep)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      (steps.length + 1).toString(),
                      style: const TextStyle(
                        fontSize: 21,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'poppins',
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: CustomTextField(
                    controller: stepController,
                    placeholder: 'step...',
                    maxLength: 5,
                    fontSize: 17,
                  ),
                ),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isStep = false;
                      steps.add(stepController.text);
                      stepController.text = '';
                    });
                  },
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF9A0A10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        CupertinoIcons.check_mark,
                        size: 15.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const Gap(15),
          const Divider(
            color: Color(0xFF9A0A10),
            thickness: 3,
            height: 3,
          ),
          const Gap(15),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NutrientInput(
                label: 'Calories',
                controller: caloriesController,
                icon: SvgPicture.asset(IconProvider.calories.buildImageUrl()),
              ),
              const Gap(5),
              NutrientInput(
                label: 'proteins',
                controller: proteinsController,
              ),
              const Gap(5),
              NutrientInput(
                label: 'fats',
                controller: fatsController,
              ),
              const Gap(5),
              NutrientInput(
                label: 'carbohydrates',
                controller: carbsController,
              ),
            ],
          ),
          const Gap(36),
          Center(
            child: GestureDetector(
              onTap: () {
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    caloriesController.text.isEmpty ||
                    proteinsController.text.isEmpty ||
                    fatsController.text.isEmpty ||
                    carbsController.text.isEmpty ||
                    _image == null ||
                    ingredients.isEmpty ||
                    steps.isEmpty ||
                    difficulty == null ||
                    cuisine == null ||
                    selectedHour + selectedMinute == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill in all fields',
                        style: TextStyle(
                          fontFamily: 'poppins',
                        ),
                      ),
                    ),
                  );
                } else {
                  context.read<RecipeBloc>().add(
                        AddRecipe(
                          RecipeModel(
                            name: titleController.text,
                            description: descriptionController.text,
                            imagePath: _image != null ? _image!.path : '',
                            spicinessLevel: spicinessLevel,
                            servings: 1,
                            difficulty: difficulty ?? 'Easy',
                            cuisine: cuisine ?? 'China',
                            time: '$selectedHour:$selectedMinute',
                            ingredients: ingredients,
                            steps: steps,
                            calories:
                                double.tryParse(caloriesController.text) ?? 0,
                            proteins:
                                double.tryParse(proteinsController.text) ?? 0,
                            fats: double.tryParse(fatsController.text) ?? 0,
                            carbs: double.tryParse(carbsController.text) ?? 0,
                          ),
                        ),
                      );
                }
              },
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF9A0A10),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 46, vertical: 21),
                  child: Text('save recipe',
                      style: TextStyle(
                        fontFamily: 'poppins',
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onRatingChanged(int rating) {
    setState(() {
      _rating = rating;
    });
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.horizontalPadding = 22,
    this.verticalPadding = 16,
    this.onSave,
    this.isSuffix = false,
    this.fontSize = 25,
    this.maxLength = 1,
    this.keyboardType,
    this.isCenterText = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final bool isSuffix;
  final String placeholder;
  final double fontSize;
  final int maxLength;
  final bool isCenterText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double horizontalPadding;
  final double verticalPadding;
  final void Function(String)? onSave;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      cursorColor: const Color(0xFF9A0A10),
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (onSave != null) {
          onSave!(controller.text);
        }
      },
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      placeholder: placeholder,
      onSubmitted: (value) {
        if (onSave != null) {
          onSave!(value);
        }
      },
      placeholderStyle: TextStyle(
        fontSize: fontSize,
        fontStyle: FontStyle.italic,
        color: const Color(0xFF8F8F8F),
        fontFamily: 'poppins',
      ),
      suffix: isSuffix
          ? const Padding(
              padding: EdgeInsets.only(right: 22),
              child: Icon(Icons.edit, color: Color(0xFF8F8F8F), size: 25),
            )
          : null,
      maxLines: maxLength,
      minLines: maxLength,
      textAlignVertical: TextAlignVertical.top,
      textAlign: isCenterText ? TextAlign.center : TextAlign.start,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: fontSize,
        color: CupertinoColors.black,
        fontFamily: 'poppins',
      ),
      decoration: customDecoration(),
    );
  }
}

class NutrientInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Widget? icon;

  const NutrientInput({
    super.key,
    required this.label,
    required this.controller,
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
        SizedBox(
          width:
              MediaQuery.of(context).size.width * 0.35, // Задайте нужную ширину
          child: CustomTextField(
            controller: controller,
            placeholder: 'Enter text...',
            verticalPadding: 8,
            horizontalPadding: 18,
            fontSize: 16,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            isCenterText: true,
          ),
        ),
      ],
    );
  }
}
