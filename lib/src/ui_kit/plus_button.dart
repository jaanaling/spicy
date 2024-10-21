import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final bool isPlus;
  final VoidCallback? onPressed;
  const PlusButton({super.key, this.onPressed, this.isPlus = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DecoratedBox(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFF9A0A10)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Icon(
            isPlus ? CupertinoIcons.plus : CupertinoIcons.minus,
            size: 15.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
