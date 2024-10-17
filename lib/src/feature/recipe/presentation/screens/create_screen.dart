import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UserTextField extends StatelessWidget {
  const UserTextField({
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
          color: Color(0xFF8F8F8F),
        ),
        suffix: isSuffix
            ? Icon(CupertinoIcons.pen, color: Color(0xFF8F8F8F), size: 25)
            : null,
        maxLength: 3,
        style: const TextStyle(fontSize: 27, color: CupertinoColors.black),
        decoration: BoxDecoration(
          color: Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12), // Радиус границ
          border: Border.all(
            color: Color(0xFFDCDCDC), // Цвет границы
            width: 0.4, // Ширина границы
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.13), // Цвет тени
              offset: Offset(0, 2), // Смещение тени
              blurRadius: 6.3, // Размытие тени
            ),
          ],
        ));
  }
}
