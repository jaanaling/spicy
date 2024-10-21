import 'package:flutter/material.dart';

BoxDecoration customDecoration() {
  return BoxDecoration(
    color: const Color(0xFFF3F3F3),
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
  );
}
