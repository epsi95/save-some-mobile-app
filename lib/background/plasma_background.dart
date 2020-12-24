import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class PlasmaBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Stack(
        children: [
          Plasma(
            particles: 10,
            foregroundColor: Color(0xFFEE0072),
            backgroundColor: Color(0xFF6200EE),
            size: 1.00,
            speed: 6.00,
            offset: 0.00,
            blendMode: BlendMode.colorDodge,
            child: Container(), // your UI here
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
            child: Container(
              height: height,
              width: width,
              decoration:
                  BoxDecoration(color: Color(0xFFA697FF).withOpacity(0.6)),
            ),
          )
        ],
      ),
    );
  }
}
