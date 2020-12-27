import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class SingleNumberAnimation extends StatelessWidget {
  final double fontSize;
  final int number;
  final int durationInMilliseconds;
  SingleNumberAnimation(
      {@required this.fontSize,
      @required this.number,
      this.durationInMilliseconds = 800});

  _getSingleDigitSize() {
    final painter = TextPainter();
    painter.text = TextSpan(style: TextStyle(fontSize: fontSize), text: '0');
    painter.textDirection = TextDirection.ltr;
    painter.textAlign = TextAlign.left;
    painter.textScaleFactor = 1.0;
    painter.layout();
    return painter.size;
  }

  @override
  Widget build(BuildContext context) {
    final Size s = _getSingleDigitSize();
    return PlayAnimation(
      tween: Tween(
          begin: (Random().nextDouble()) * number * (s.height),
          end: number * (s.height)),
      duration: Duration(milliseconds: durationInMilliseconds),
      curve: Curves.easeOut,
      builder: (context, child, value) {
        return SizedOverflowBox(
          alignment: Alignment.topCenter,
          size: s,
          child: ClipRect(
            clipper: CustomDigitClipper(s),
            child: Transform.translate(
              offset: Offset(0, -value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  for (var i = 0; i < 10; i++)
                    Text(
                      i.toString(),
                      textScaleFactor: 1.0,
                      style: TextStyle(fontSize: fontSize, color: Colors.white),
                    )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class CustomDigitClipper extends CustomClipper<Rect> {
  CustomDigitClipper(this.digitSize);
  final Size digitSize;

  @override
  Rect getClip(Size size) {
//    print('CC ${digitSize.height}');
    return Rect.fromPoints(
        Offset.zero, Offset(digitSize.width, digitSize.height));
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
