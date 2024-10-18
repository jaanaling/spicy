import 'dart:io';
import 'dart:ui';

import 'package:application/src/feature/recipe/model/recipe.dart';
import 'package:application/src/ui_kit/custom_decoration.dart';
import 'package:application/src/ui_kit/raiting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  TextEditingController proteinsController = TextEditingController();
  TextEditingController fatsController = TextEditingController();
  TextEditingController carbsController = TextEditingController();

  String? difficulty;
  String? cuisine;
  int spicinessLevel = 1;
  int selectedHour = 0;
  int selectedMinute = 0;

  List<TextEditingController> stepsController = [];
  List<Ingredient> ingredients = [];

  List<TextEditingController> ingredientsController = [];
  File? _image; // Выбранное изображение
  final ImagePicker _picker = ImagePicker();

  List<String> countries = [
    'China',
    'India',
    'South Korea',
    'Vietnam',
    'Thailand',
    'Malaysia',
  ];
  int selectedIndex = 0;
  int _rating = 1;

  void _showCountrySnackBar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Country',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: const Text('Done'),
                onPressed: () {
                  Navigator.pop(context);
                  cuisine = countries[selectedIndex];
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<int> hours = List<int>.generate(24, (index) => index);
  List<int> minutes = List<int>.generate(60, (index) => index);

  // Функция для выбора изображения из галереи
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
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: CupertinoColors.systemBackground,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Select Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                child: const Text('Done'),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
        child: Column(
          children: [
            CustomTextField(
              controller: titleController,
              placeholder: 'Enter title...',
              isSuffix: true,
            ),
            Row(
              children: [
                const Stack(
                  children: [],
                ),
                Column(
                  children: [
                    DecoratedBox(
                      decoration: customDecoration(),
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
                              style: const TextStyle(fontSize: 21),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.51),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: customDecoration(),
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
                                  ? '$hours:$minutes'
                                  : 'Time',
                              style: const TextStyle(fontSize: 21),
                            ),
                            Icon(
                              CupertinoIcons.chevron_down,
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.51),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Rating(rating: _rating, onRatingChanged: _onRatingChanged)
                  ],
                ),
              ],
            ),
            Expanded(
              child: CustomTextField(
                controller: descriptionController,
                placeholder: 'Enter description...',
                isSuffix: true,
              ),
            ),
          ],
        ),
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
      controller: controller,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (onSave != null) {
          onSave!(controller.text);
        }
      },
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
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
      ),
      suffix: isSuffix
          ? const Icon(CupertinoIcons.pen, color: Color(0xFF8F8F8F), size: 25)
          : null,
      maxLength: 3,
      style: const TextStyle(fontSize: 27, color: CupertinoColors.black),
      decoration: customDecoration(),
    );
  }
}
