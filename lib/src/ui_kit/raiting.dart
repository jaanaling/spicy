import 'package:flutter/material.dart';
import 'package:application/src/core/utils/icon_provider.dart';

class Rating extends StatefulWidget {
  final int rating;
  final Function(int)? onRatingChanged;

  const Rating({
    Key? key,
    required this.rating,
    required this.onRatingChanged,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (widget.onRatingChanged != null) {
                widget.onRatingChanged!(index);
              }
            });
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Image.asset(
              key: ValueKey(index <= widget.rating),
              width: 25,
              height: 41,
              index > widget.rating
                  ? IconProvider.pepperInactive.buildImageUrl()
                  : IconProvider.pepper.buildImageUrl(),
            ),
          ),
        );
      }),
    );
  }
}
