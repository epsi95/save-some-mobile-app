import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData data({type: 'weekly'}) {
  List<String> weekDataLabel = [
    'THU',
    'FRI',
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED'
  ];
  List<double> weekData = [50.0, 100, 150, 40];
  double monthlyMaximumExpenditure = 3000.0;
  double weeklyMaximumExpenditure = monthlyMaximumExpenditure / 4;
  double dailyMaximumExpenditure =
      (weeklyMaximumExpenditure / 7).floor().toDouble();

  return (type == 'weekly')
      ? LineChartData(
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white.withOpacity(0.3),
            ),
            touchCallback: (LineTouchResponse touchResponse) {},
            handleBuiltInTouches: true,
          ),
          gridData: FlGridData(
            show: false,
          ),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              margin: 10,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 1:
                    return weekDataLabel[0];
                  case 2:
                    return weekDataLabel[1];
                  case 3:
                    return weekDataLabel[2];
                  case 4:
                    return weekDataLabel[3];
                  case 5:
                    return weekDataLabel[4];
                  case 6:
                    return weekDataLabel[5];
                  case 7:
                    return weekDataLabel[6];
                }
                return '';
              },
            ),
            leftTitles: SideTitles(
              interval: weeklyMaximumExpenditure / 3,
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              getTitles: (value) {
                return value.toInt().toString();
              },
              margin: 8,
              reservedSize: 30,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Color(0xFFFFFFFF),
                width: 2,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
              top: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          minX: 0,
          maxX: weekDataLabel.length.toDouble(),
          maxY: weeklyMaximumExpenditure * 1.2,
          minY: 0,
          lineBarsData: weeklyLineBarData(
              weekData, dailyMaximumExpenditure, weeklyMaximumExpenditure),
        )
      : null;
}

List<LineChartBarData> weeklyLineBarData(List<double> weekData,
    double dailyMaximumExpenditure, double weeklyMaximumExpenditure) {
  print(weeklyMaximumExpenditure);
  List<FlSpot> data = [];
  weekData.asMap().forEach((key, value) {
    data.add(FlSpot((key + 1).toDouble(), value));
  });
  final LineChartBarData actualUsageLineData = LineChartBarData(
    spots: data,
    isCurved: true,
    colors: [
      const Color(0xFFFFFFFF),
    ],
    barWidth: 5,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData maxDailyUsageLineData = LineChartBarData(
    spots: [
      FlSpot(1, dailyMaximumExpenditure),
      FlSpot(2, dailyMaximumExpenditure),
      FlSpot(3, dailyMaximumExpenditure),
      FlSpot(4, dailyMaximumExpenditure),
      FlSpot(5, dailyMaximumExpenditure),
      FlSpot(6, dailyMaximumExpenditure),
      FlSpot(7, dailyMaximumExpenditure),
    ],
    isCurved: true,
    colors: [
      const Color(0x7DFFFFFF),
    ],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData maxWeeklyUsageLineData = LineChartBarData(
    spots: [
      FlSpot(1, weeklyMaximumExpenditure),
      FlSpot(2, weeklyMaximumExpenditure),
      FlSpot(3, weeklyMaximumExpenditure),
      FlSpot(4, weeklyMaximumExpenditure),
      FlSpot(5, weeklyMaximumExpenditure),
      FlSpot(6, weeklyMaximumExpenditure),
      FlSpot(7, weeklyMaximumExpenditure),
    ],
    isCurved: true,
    colors: [
      const Color(0x7DFFFFFF),
    ],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData weeklyCumulativeLineData = LineChartBarData(
    spots: [
      FlSpot(1, 50.0),
      FlSpot(2, 50.0 + 100.0),
      FlSpot(3, 50.0 + 100.0 + 150.0),
      FlSpot(4, 50.0 + 100.0 + 150.0 + 40.0),
    ],
    isCurved: true,
    colors: [
      const Color(0x7DFFFFFF),
    ],
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  final LineChartBarData predictionLineData = LineChartBarData(
    spots: [
      FlSpot(4, 40.0),
      FlSpot(5, 90.0),
      FlSpot(6, 92.0),
      FlSpot(7, 94.0),
    ],
    dashArray: [5, 10],
    isCurved: true,
    colors: [
      const Color(0x7DFFFFFF),
    ],
    barWidth: 6,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: false,
    ),
    belowBarData: BarAreaData(
      show: false,
    ),
  );
  return [
    actualUsageLineData,
    maxDailyUsageLineData,
    predictionLineData,
    maxWeeklyUsageLineData,
    weeklyCumulativeLineData
  ];
}
