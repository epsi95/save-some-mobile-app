import 'package:flutter/material.dart';
import 'pages/dashboard.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          //backgroundColor: Color(0xFFE5E5E5),
          body: Dashboard(),
        ),
      ),
    );
  }
}
