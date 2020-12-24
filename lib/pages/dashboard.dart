import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:savesome/background/blobs.dart';
import 'package:savesome/background/plasma_background.dart';
import 'package:savesome/graphs/graph.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double expenseLimit = 120;
  double savings = 80;
  String currencySign = '₹';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlasmaBackground(),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$expenseLimit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 52,
                      ),
                    ),
                    Text(
                      currencySign,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                Text(
                  'Today\'s expenditure',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: Text(
                    "Savings $savings",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              height: 200,
              child: Center(
                child: LineChart(
                  data(type: 'weekly'),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
