import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savesome/background/blobs.dart';
import 'package:savesome/background/plasma_background.dart';
import 'package:savesome/graphs/graph.dart';
import 'package:savesome/custom_element/graph_toggle_button.dart';
import 'package:savesome/pages/my_details.dart';
import 'package:savesome/utils/database.dart';
import 'package:savesome/utils/multi_number_animation.dart';

class Dashboard extends StatefulWidget {
  final double todayExpenditure;
  final double savings;
  final String currencySign;
  final Map graphData;
  Dashboard(
      this.todayExpenditure, this.savings, this.currencySign, this.graphData);
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
  TextEditingController _tc = TextEditingController();
  TextEditingController _whatForController = TextEditingController();

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
                  controller: _whatForController,
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
                  controller: _tc,
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
                  print(double.parse(_tc.text.toString()));
                  double tmp = double.parse(_tc.text.toString());
                  String whatFor = _whatForController.text.toString();
                  if (_todayExpenditure + tmp < 0.0) {
                    print('can\'t go below 0');
                  } else {
                    DataBase.insertIntoDataBase(tmp, whatFor);
                  }
                  _tc.clear();
                  _whatForController.clear();
                  _initializeParameters();
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
    if (_currentGraphType == 'week') {
      _graphData = await DataBase.getWeekData();
    } else {
      _graphData = await DataBase.getWeekData();
    }
    _graphPlaceHolderWidget = LineChart(
      weekLineChart(_graphData),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
    setState(() {});
  }

  void _initializeParameters() async {
    _todayExpenditure = await DataBase.getTodayExpenditure();
    print(_todayExpenditure);
    _savings = await DataBase.getDailyUsageLimit() - _todayExpenditure;
    _savings = (_savings * 10).roundToDouble() / 10;
    _currencySign = await DataBase.getCurrencySign();

    _takeUserInput = true;
    _initializeGraph();
  }

  @override
  void initState() {
    _todayExpenditure = widget.todayExpenditure;
    _savings = widget.savings;
    _currencySign = widget.currencySign;
    _graphData = widget.graphData;
    _graphPlaceHolderWidget = LineChart(
      weekLineChart(_graphData),
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
    _takeUserInput = true;
    super.initState();
  }

  @override
  void dispose() {
    _tc.dispose();
    _whatForController.dispose();
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
                  PopupMenuButton<PopUpMenuItems>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 28,
                        color: Colors.white,
                      ),
                      onSelected: (PopUpMenuItems i) async {
                        switch (i) {
                          case PopUpMenuItems.deleteDataBase:
                            DataBase.deleteAllData();
                            _initializeParameters();
                            break;
                          case PopUpMenuItems.printAll:
                            DataBase.printAllDataFromDataBase();
                            break;
                          case PopUpMenuItems.limit:
                            double monthlyUsageLimit =
                                await DataBase.getMonthlyUsageLimit();
                            String currency = await DataBase.getCurrencySign();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyDetails(
                                  monthlyUsageLimit: monthlyUsageLimit,
                                  currencySymbol: currency,
                                ),
                              ),
                            ).then((value) {
                              _initializeParameters();
                            });
                            break;
                          default:
                            print(i);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<PopUpMenuItems>>[
                            const PopupMenuItem<PopUpMenuItems>(
                              value: PopUpMenuItems.limit,
                              child: Text(
                                'Settings',
                                textScaleFactor: 1.0,
                              ),
                            ),
                            const PopupMenuItem<PopUpMenuItems>(
                              value: PopUpMenuItems.history,
                              child: Text(
                                'History Check',
                                textScaleFactor: 1.0,
                              ),
                            ),
                            const PopupMenuItem<PopUpMenuItems>(
                              value: PopUpMenuItems.deleteDataBase,
                              child: Text(
                                'Delete Old Data',
                                textScaleFactor: 1.0,
                              ),
                            ),
                            const PopupMenuItem<PopUpMenuItems>(
                              value: PopUpMenuItems.printAll,
                              child: Text(
                                'PrintAllData',
                                textScaleFactor: 1.0,
                              ),
                            ),
                            const PopupMenuItem<PopUpMenuItems>(
                              value: PopUpMenuItems.about,
                              child: Text(
                                'About',
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ]),
//                  IconButton(
//                    icon: Icon(Icons.more_vert),
//                    iconSize: 28,
//                    color: Colors.white,
//                    onPressed: () {
//                      DataBase.printAllDataFromDataBase();
//                    },
//                  )
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

enum PopUpMenuItems { limit, history, deleteDataBase, about, printAll }
