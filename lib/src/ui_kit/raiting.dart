import 'package:application/src/core/utils/icon_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

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
            widget.onRatingChanged != null
                ? widget.onRatingChanged!(index + 1)
                : null;
          },
          child: SvgPicture.asset(
             IconProvider.pepper.buildImageUrl(),
            colorFilter: index < widget.rating
                ? ColorFilter.matrix([
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0.2126,
                    0.7152,
                    0.0722,
                    0,
                    0,
                    0,
                    0,
                    0,
                    1,
                    0,
                  ])
                : null,
          ),
        );
      }),
    );
  }
}
