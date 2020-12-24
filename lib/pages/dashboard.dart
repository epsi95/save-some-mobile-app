import 'package:flutter/material.dart';
import 'package:savesome/background/blobs.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double expenseLimit = 250.5;
  double limit = 300;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Blobs(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.white,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  color: Colors.white,
                  onPressed: () {},
                )
              ],
            ),
            Center(
                child: Column(
              children: [
                Text(
                  "$expenseLimit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 46,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Text(
                    "Limit: $limit",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            )),
          ],
        )
      ],
    );
  }
}
