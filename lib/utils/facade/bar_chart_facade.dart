import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartFacade {
  final int highestNum;
  final Color mainColor;
  final Color thirdColor;
  final double width;

  BarChartFacade({
    required this.highestNum,
    required this.mainColor,
    required this.thirdColor,
    required this.width,
  });

  BarChartData generateChartData({
    required List<int> bookBorrowList,
    required List<int> bookImportList,
    required FlTitlesData titlesData,
    required void Function(int month, int barIndex) onBarTap,
  }) {
    int topValue = highestNum - highestNum % 10 + 10;

    return BarChartData(
      minY: 0,
      maxY: topValue.toDouble(),
      titlesData: titlesData,
      barTouchData: barTouchData(onBarTap),
      borderData: FlBorderData(
        border: const Border(
          bottom: BorderSide(width: 1),
          left: BorderSide(width: 1),
        ),
      ),
      barGroups: buildBarGroup(bookBorrowList, bookImportList),
      gridData: const FlGridData(show: false),
    );
  }

  BarTouchData barTouchData(void Function(int month, int barIndex) onBarTap) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(),
      touchCallback: (event, response) {
        if (event is FlTapUpEvent) {
          if (response == null) return;
          if (response.spot?.touchedBarGroupIndex == null) return;
          if (response.spot?.touchedRodDataIndex == null) return;

          onBarTap(
            response.spot!.touchedBarGroupIndex,
            response.spot!.touchedRodDataIndex,
          );
        }
      },
    );
  }

  List<BarChartGroupData> buildBarGroup(
      List<int> bookBorrowList, List<int> bookImportList) {
    return List.generate(
      bookBorrowList.length,
      (index) => buildBar(
        index,
        bookBorrowList[index].toDouble(),
        bookImportList[index].toDouble(),
      ),
    );
  }

  BarChartGroupData buildBar(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 5,
      x: x + 1,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: mainColor,
          width: width,
          borderRadius: BorderRadius.circular(3),
        ),
        BarChartRodData(
          toY: y2,
          color: thirdColor,
          width: width,
          borderRadius: BorderRadius.circular(3),
        ),
      ],
    );
  }
}
