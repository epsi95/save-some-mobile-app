import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData data({type: 'weekly'}) {
  List<String> weekDataLabel = [
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT'
  ];
  List<double> weekData = [50.0, 100, 150, 40];
  double monthlyMaximumExpenditure = 3000.0;
  double weeklyMaximumExpenditure = monthlyMaximumExpenditure / 4;
  double dailyMaximumExpenditure = weeklyMaximumExpenditure / 7;

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
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              getTitles: (value) {
                if (value == dailyMaximumExpenditure.toInt()) {
                  return 'MAX';
                }
                return '';
              },
              margin: 8,
              reservedSize: 30,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Colors.white,
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
          maxY: dailyMaximumExpenditure * 1.5,
          minY: 0,
          lineBarsData: weeklyLineBarData(weekData, dailyMaximumExpenditure),
        )
      : null;
}

List<LineChartBarData> weeklyLineBarData(
    List<double> weekData, double dailyMaximumExpenditure) {
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
  final LineChartBarData maxUsageLineData = LineChartBarData(
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
      const Color(0xFFFFFFFF),
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
  return [actualUsageLineData, maxUsageLineData];
}
