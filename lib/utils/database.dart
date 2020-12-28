import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:savesome/utils/polynomial_regression.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBase {
  static Future<Map> getWeekDataForTesting() async {
    DateTime today = DateTime.now();
    return Future.delayed(Duration(milliseconds: 200), () {
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

  static Future<Map> getWeekData() async {
    List<FlSpot> actualUsageData = [];
    List<FlSpot> weeklyCumulativeData = [];
    List<double> expenseData = [];
    List<int> toBePredicted = [];
    List<double> predictionData = [];
    List<FlSpot> predictionData_ = [];
    // monday 1, sunday 7
    DateTime today = DateTime.now();
    int weekday = today.weekday;
    int todayInMilli =
        DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
    List<int> requiredData = [];
    for (int i = 1; i <= weekday; i++) {
      requiredData.add(todayInMilli - (weekday - i) * (24 * 60 * 60 * 1000));
    }
    List<Map<dynamic, dynamic>> result = await getExpenseDataFromDateRange(
        requiredData[0], requiredData[requiredData.length - 1]);
    requiredData.asMap().forEach((key, value) {
      double tmp = 0.0;
      double cumulative = 0.0;
      result.forEach((element) {
        if (element['onlyDayMillisecondsSinceEpoch'] == value) {
          tmp = element['totalExpense'].toDouble();
        }
      });
      expenseData.add(tmp);
      actualUsageData.add(FlSpot(key + 1.0, tmp));
      cumulative += tmp;
      weeklyCumulativeData.add(FlSpot(key + 1.0, cumulative));
    });
    for (int i = weekday + 1; i <= 7; i++) {
      toBePredicted.add(i);
    }
    predictionData.add(expenseData[expenseData.length - 1]);
    predictionData = [
      ...predictionData,
      ...calculatePolynomialRegression(expenseData, toBePredicted)
    ];
    predictionData.asMap().forEach((key, value) {
      predictionData_.add(FlSpot(key + 1.0, value));
    });
    print(actualUsageData);
    print(weeklyCumulativeData);
    print(predictionData_);

    double m = await getMonthlyUsageLimit();
    int dayInMonth = DateTime(today.year, today.month + 1, 0).day;
    double w = ((m / 4) * 10).roundToDouble() / 10;
    double d = ((m / dayInMonth) * 10).roundToDouble() / 10;
    return {
      'monthlyMaximumExpenditure': m,
      'weeklyMaximumExpenditure': w,
      'dailyMaximumExpenditure': d,
      'weekDataLabel': ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'],
      'actualUsageData': actualUsageData,
      'weeklyCumulativeData': weeklyCumulativeData,
      'predictionData': predictionData_
    };
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

  static Future<double> getTodayExpenditure() async {
    final Database db = await database();
    DateTime today = DateTime.now();
    List<Map<String, dynamic>> result = await db.rawQuery("""
    SELECT SUM(expense) FROM expense
    WHERE onlyDayMillisecondsSinceEpoch = ${DateTime(today.year, today.month, today.day).millisecondsSinceEpoch}
    """);
    //print(result);
    return (result[0]['SUM(expense)'] ?? 0).toDouble();
  }

  static Future<List<Map<String, dynamic>>> getExpenseDataFromDateRange(
      int from, int to) async {
    final Database db = await database();
    List<Map<String, dynamic>> result = await db.rawQuery("""
    SELECT
  onlyDayMillisecondsSinceEpoch, SUM(expense) as totalExpense
FROM
  (
    SELECT
      *
    FROM
      expense
    WHERE
      onlyDayMillisecondsSinceEpoch BETWEEN $from
      AND $to
    ORDER BY
      onlyDayMillisecondsSinceEpoch ASC
  )
GROUP BY
  onlyDayMillisecondsSinceEpoch;
    """);
    return result;
  }

  static Future<void> setCurrencySign(String sign) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('currencySign', sign);
  }

  static Future<String> getCurrencySign() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('currencySign');
  }

  static Future<void> printAllDataFromDataBase() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query('expense');
    print(maps);
  }

  static Future<bool> getFirstTimeUsingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstTimeUsing') ?? true;
  }

  static Future<void> setFirstTimeUsingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstTimeUsing', false);
  }

  static Future<void> insertIntoDataBase(double expense, String whatFor) async {
    final Database db = await database();
    expense = (expense * 10).roundToDouble() / 10;
    DateTime today = DateTime.now();
    int onlyDayMillisecondsSinceEpoch =
        DateTime(today.year, today.month, today.day).millisecondsSinceEpoch;
    int millisecondsSinceEpoch = today.millisecondsSinceEpoch;
    Expenditure e = Expenditure(
        onlyDayMillisecondsSinceEpoch,
        millisecondsSinceEpoch,
        today.year,
        today.month,
        today.weekday,
        expense,
        whatFor);
    await db.insert(
      'expense',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('DATABASE CLASS: database insertion complete');
  }

  static Future<void> deleteAllData() async {
    final Database db = await database();
    db.delete('expense');
    print('database deleted');
  }

  static Future<Database> database() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'expense_database.db'),
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE expense(
                      onlyDayMillisecondsSinceEpoch INTEGER NOT NULL, 
                      millisecondsSinceEpoch INTEGER NOT NULL,
                      yearNumber INTEGER NOT NULL, 
                      monthNumber INTEGER NOT NULL, 
                      weekNumber INTEGER NOT NULL,
                      expense DECIMAL(10,1) NOT NULL,
                      forWhat VARCHAR(255) DEFAULT '' 
                      )
                      """,
        );
      },
      version: 1,
    );
    return database;
  }
}

class Expenditure {
  int onlyDayMillisecondsSinceEpoch;
  int millisecondsSinceEpoch;
  int yearNumber;
  int monthNumber;
  int weekNumber;
  double expense;
  String forWhat;

  Expenditure(
      this.onlyDayMillisecondsSinceEpoch,
      this.millisecondsSinceEpoch,
      this.yearNumber,
      this.monthNumber,
      this.weekNumber,
      this.expense,
      this.forWhat);

  Map<String, dynamic> toMap() {
    return {
      'onlyDayMillisecondsSinceEpoch': onlyDayMillisecondsSinceEpoch,
      'millisecondsSinceEpoch': millisecondsSinceEpoch,
      'monthNumber': monthNumber,
      'yearNumber': yearNumber,
      'weekNumber': weekNumber,
      'expense': expense,
      'forWhat': forWhat
    };
  }
}
