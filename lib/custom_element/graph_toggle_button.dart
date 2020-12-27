import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class GraphToggleButton extends StatefulWidget {
  final Function buttonPressed;
  GraphToggleButton({this.buttonPressed});
  @override
  _GraphToggleButtonState createState() => _GraphToggleButtonState();
}

class _GraphToggleButtonState extends State<GraphToggleButton> {
  CustomAnimationControl control = CustomAnimationControl.STOP;
  String bgPosition = 'weekly';

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<double>(
      tween: Tween(begin: 0.0, end: 100.0),
      duration: Duration(milliseconds: 380),
      curve: Curves.easeInOut,
      control: control,
      builder: (context, child, value) {
        return Container(
          width: 200.0,
          height: 50.0,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.only(left: value),
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    height: 40,
                    width: (value <= 50) ? (value + 100) : (200 - value),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.buttonPressed('weekly');
                        if (bgPosition == 'monthly') {
                          setState(() {
                            control =
                                CustomAnimationControl.PLAY_REVERSE_FROM_END;
                            bgPosition = 'weekly';
                          });
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        child: Center(
                          child: Text(
                            "week",
                            textScaleFactor: 1.0,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.buttonPressed('monthly');
                        if (bgPosition == 'weekly') {
                          setState(() {
                            control = CustomAnimationControl.PLAY;
                            bgPosition = 'monthly';
                          });
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 50,
                        child: Center(
                          child: Text(
                            "month",
                            textScaleFactor: 1.0,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
