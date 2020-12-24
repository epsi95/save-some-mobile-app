import 'package:flutter/material.dart';
import 'package:savesome/background/blobs.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Blobs(),
      ],
    );
  }
}
