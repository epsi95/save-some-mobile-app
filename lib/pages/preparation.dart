import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Preparation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Container(
      height: s.height,
      width: s.width,
      color: Color(0xFFAE00FF),
      child: Center(
        child:
            Lottie.asset('assets/loading_animation.json', fit: BoxFit.fitWidth),
      ),
    );
  }
}
