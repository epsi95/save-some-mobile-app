import 'package:flutter/material.dart';
import 'package:savesome/utils/single_number_animation.dart';

class MultiNumberAnimation extends StatelessWidget {
  final String numberString;
  final double fontSize;
  MultiNumberAnimation(
      {@required this.numberString, @required this.fontSize, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final lengthOfNumber = numberString.length;
    List<int> numbers = [];
    for (int i = 0; i < lengthOfNumber; i++) {
      numbers.add(int.parse(numberString[i]));
    }
    return Row(
      children: [
        for (int i = 0; i < lengthOfNumber; i++)
          SingleNumberAnimation(
              fontSize: fontSize, number: int.parse(numberString[i]))
      ],
    );
  }
}
