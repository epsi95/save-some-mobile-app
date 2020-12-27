import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savesome/background/blobs.dart';
import 'package:savesome/background/plasma_background.dart';
import 'package:savesome/graphs/graph.dart';
import 'package:savesome/custom_element/graph_toggle_button.dart';
import 'package:savesome/utils/database.dart';
import 'package:savesome/utils/multi_number_animation.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double _todayExpenditure = 0.0;
  double _savings = 0.0;
  String _currencySign = '';
  String _currentGraphType = 'week';
  Map _graphData;
  Widget _graphPlaceHolderWidget = Container();
  bool _takeUserInput = false;
  TextEditingController tc = TextEditingController();
  TextEditingController whatForController = TextEditingController();

  void _buttonPressed(buttonName) {
    _currentGraphType = buttonName;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Put Expenses',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: whatForController,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.title,
                        color: Colors.grey,
                      ),
                      hintText: 'What for?'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  controller: tc,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.account_balance_wallet,
                        color: Colors.grey,
                      ),
                      hintText: 'Enter an expenditure'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                try {
                  print(double.parse(tc.text.toString()));
                  setState(() {
                    _todayExpenditure += double.parse(tc.text.toString());
                    _todayExpenditure =
                        _todayExpenditure < 0.0 ? 0.0 : _todayExpenditure;
                    tc.clear();
                    whatForController.clear();
                  });
                  print(_todayExpenditure);
                } catch (e) {
                  print('unable to parse $e');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _initializeGraph() async {
    _graphData = _currentGraphType == 'week'
        ? await DataBase.getWeekData()
        : await DataBase.getMonthData();
    _graphPlaceHolderWidget = LineChart(
      weekLineChart(_graphData),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
    setState(() {});
  }

  void _initializeParameters() async {
    await DataBase.openDataBase();
    _todayExpenditure = await DataBase.getTodayExpenditure();
    _savings = await DataBase.getDailyUsageLimit() - _todayExpenditure;
    _currencySign = await DataBase.getCurrencySign();

    _takeUserInput = true;
    _initializeGraph();
  }

  @override
  void initState() {
    _initializeParameters();
    super.initState();
  }

  @override
  void dispose() {
    tc.dispose();
    whatForController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlasmaBackground(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    iconSize: 28,
                    color: Colors.white,
                    onPressed: _takeUserInput
                        ? () {
                            _showMyDialog();
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    iconSize: 28,
                    color: Colors.white,
                    onPressed: () {
                      print(_todayExpenditure.toString().split('.')[0]);
                    },
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MultiNumberAnimation(
                        key: UniqueKey(),
                        fontSize: 55.0,
                        numberString:
                            _todayExpenditure.toString().split('.')[0]),
                    Text(
                      ".",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 55,
                      ),
                    ),
                    MultiNumberAnimation(
                        key: UniqueKey(),
                        numberString:
                            _todayExpenditure.toString().split('.')[1],
                        fontSize: 55),
                    Text(
                      _currencySign,
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
                Text(
                  'Today\'s expenditure',
                  textScaleFactor: 1.0,
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                    "Savings $_savings",
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                )
              ],
            ),
            Container(
              height: 250,
              child: Center(
                child: _graphPlaceHolderWidget,
              ),
            ),
            GraphToggleButton(
              buttonPressed: _buttonPressed,
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        )
      ],
    );
  }
}
