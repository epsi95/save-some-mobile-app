import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData weekLineChart(Map data) {
  List<String> weekDataLabel = data['weekDataLabel'];
  List<FlSpot> weekData = data['actualUsageData'];
  List<FlSpot> predictionData = data['predictionData'];
  List<FlSpot> cumulativeData = data['weeklyCumulativeData'];
  double monthlyMaximumExpenditure = data['monthlyMaximumExpenditure'];
  double weeklyMaximumExpenditure = data['weeklyMaximumExpenditure'];
  double dailyMaximumExpenditure = data['dailyMaximumExpenditure'];

  return LineChartData(
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
    lineBarsData: weeklyLineBarData(weekData, dailyMaximumExpenditure,
        weeklyMaximumExpenditure, predictionData, cumulativeData),
  );
}

List<LineChartBarData> weeklyLineBarData(
    List<FlSpot> weekData,
    double dailyMaximumExpenditure,
    double weeklyMaximumExpenditure,
    List<FlSpot> predictionData,
    List<FlSpot> cumulativeData) {
  print(weeklyMaximumExpenditure);
  final LineChartBarData actualUsageLineData = LineChartBarData(
    spots: weekData,
    isCurved: true,
    colors: [
      const Color(0xFFFFFFFF),
    ],
    barWidth: 5,
    isStrokeCapRound: true,
    dotData: FlDotData(
      show: true,
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
    spots: cumulativeData,
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
    spots: predictionData,
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
