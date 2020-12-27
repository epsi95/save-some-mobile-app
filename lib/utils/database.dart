import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  static Future<Map> getWeekData() async {
    return Future.delayed(Duration(seconds: 1), () {
      double m = 3000.0;
      double w = ((m / 4) * 10).roundToDouble() / 10;
      double d = ((w / 7) * 10).roundToDouble() / 10;
      return {
        'monthlyMaximumExpenditure': m,
        'weeklyMaximumExpenditure': w,
        'dailyMaximumExpenditure': d,
        'weekDataLabel': ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
        'actualUsageData': [
          FlSpot(1, 50.0),
          FlSpot(2, 30.0),
          FlSpot(3, 120.0),
          FlSpot(4, 10.0),
          FlSpot(5, 50.0),
        ],
        'weeklyCumulativeData': [
          FlSpot(1, 50.0),
          FlSpot(2, 80.0),
          FlSpot(3, 200.0),
          FlSpot(4, 210.0),
          FlSpot(5, 260.0),
        ],
        'predictionData': [
          FlSpot(5, 50.0),
          FlSpot(6, 60),
          FlSpot(7, 64),
        ]
      };
//      return [
//        [50.0, 30.0, 120.0, 10.0, 50.0, 30.0, 70.0],
//        ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
//      ];
    });
  }

  static Future<List> getMonthData() async {
    return Future.delayed(Duration(seconds: 1), () {
      return [
        [
          50.0,
          30.0,
          120.0,
          10.0,
          50.0,
          30.0,
          70.0,
          30.0,
          120.0,
          10.0,
          50.0,
          30.0
        ],
        ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
      ];
    });
  }

  static List getCumulative(List d) {
    if (d.length == 0) {
      return [];
    } else {
      double tmp = 0.0;
      List output = [];
      d.forEach((element) {
        output.add(element + tmp);
        tmp += element;
      });
      return output;
    }
  }

  static void setMonthlyUsageLimit(double monthlyUsageLimit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyUsageLimit', monthlyUsageLimit);
  }

  static Future<double> getMonthlyUsageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('monthlyUsageLimit') ?? 0.0;
  }

  static Future<double> getWeeklyUsageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (((prefs.getDouble('monthlyUsageLimit') ?? 0.0) / 4) * 10)
            .roundToDouble() /
        10;
  }

  static Future<double> getDailyUsageLimit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime today = DateTime.now();
    int daysInThisMonth = DateTime(today.year, today.month + 1, 0).day;
    return (((prefs.getDouble('monthlyUsageLimit') ?? 0.0) / daysInThisMonth) *
                10)
            .roundToDouble() /
        10;
  }

  static Future<double> getTodayExpenditure() {
    return Future.delayed(Duration(milliseconds: 20), () {
      return 120.0;
    });
  }

  static Future<void> setCurrencySign(String sign) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currencySign', sign);
  }

  static Future<String> getCurrencySign() {
    return Future.delayed(Duration(milliseconds: 20), () {
      return '₹';
    });
  }

  static Future<void> openDataBase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'expense_database.db'),
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE expense(
                      millisecondsSinceEpoch INTEGER PRIMARY KEY, 
                      monthNumber INTEGER NOT NULL, 
                      weekNumber INTEGER NOT NULL,
                      expense DECIMAL(10,1) NOT NULL
                      )
                      """,
        );
      },
      version: 1,
    );
  }
}

class Expenditure {
  int millisecondsSinceEpoch;
  int monthNumber;
  int weekNumber;
  double expense;

  Expenditure(this.millisecondsSinceEpoch, this.monthNumber, this.weekNumber,
      this.expense);

  Map<String, dynamic> toMap() {
    return {
      'millisecondsSinceEpoch': millisecondsSinceEpoch,
      'monthNumber': monthNumber,
      'weekNumber': weekNumber,
      'expense': expense,
    };
  }
}
