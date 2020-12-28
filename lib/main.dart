import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:savesome/pages/first_time_input.dart';
import 'package:savesome/pages/preparation.dart';
import 'package:savesome/utils/database.dart';
import 'pages/dashboard.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Widget body = Preparation();
  double todayExpenditure;
  double savings;
  String currencySign;
  Map graphData;
  double dailyUsageLimit;
  void _prepareApp() async {
    await DataBase.database();
    if (await DataBase.getFirstTimeUsingStatus()) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FirstTimeInput(
            monthlyUsageLimit: 0.0,
            currencySymbol: '₹',
          ),
        ),
      ).then((value) async {
        dailyUsageLimit = await DataBase.getDailyUsageLimit();
        if (dailyUsageLimit == 0.0) {
          SystemNavigator.pop();
        }
      });
    }
    todayExpenditure = await DataBase.getTodayExpenditure();
    savings = await DataBase.getDailyUsageLimit() - todayExpenditure;
    currencySign = await DataBase.getCurrencySign();
    graphData = await DataBase.getWeekData();

    Future.delayed(Duration(milliseconds: 1500), () {
      body = Dashboard(todayExpenditure, savings, currencySign, graphData);
      setState(() {});
    });
  }

  @override
  void initState() {
    _prepareApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //backgroundColor: Color(0xFFE5E5E5),
        body: body,
      ),
    );
  }
}
