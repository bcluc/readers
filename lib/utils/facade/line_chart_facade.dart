import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:readers/utils/facade/chart_axis_facade.dart';

class LineChartFacade {
  final List<int> countDocGia;
  final int highestNum;
  final Color mainColor;
  final Color secondaryColor;

  LineChartFacade({
    required this.countDocGia,
    required this.highestNum,
    required this.mainColor,
    required this.secondaryColor,
  });

  LineChartData generateChartData({
    required void Function(int month) onSpotTap,
  }) {
    int topValue = highestNum - highestNum % 10 + 10;
    List<FlSpot> spots = List.generate(
      countDocGia.length,
      (i) => FlSpot(i + 1, countDocGia[i].toDouble()),
    );

    final LineChartBarData lineChartBarData = LineChartBarData(
      color: mainColor,
      spots: spots,
      barWidth: 2,
      belowBarData: BarAreaData(show: true, color: mainColor.withOpacity(0.3)),
    );

    return LineChartData(
      minX: 1,
      maxX: 12,
      minY: 0,
      maxY: topValue.toDouble(),
      titlesData: ChartAxisFacade().buildAxis(topValue, "ĐỘC GIẢ"),
      borderData: FlBorderData(
          border: const Border(
              bottom: BorderSide(width: 1), left: BorderSide(width: 1))),
      lineBarsData: [lineChartBarData],
      lineTouchData: LineTouchData(
        enabled: true,
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          if (event is FlTapUpEvent) {
            if (touchResponse == null ||
                touchResponse.lineBarSpots == null ||
                touchResponse.lineBarSpots!.isEmpty) {
              return;
            }
            final touchedSpotIndex = touchResponse.lineBarSpots!.first.spotIndex;
            onSpotTap(touchedSpotIndex);
          }
        },
        touchTooltipData: LineTouchTooltipData(
          tooltipRoundedRadius: 5,
          tooltipBorder:
              const BorderSide(width: 1, color: Colors.transparent),
          tooltipMargin: -50,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map(
              (LineBarSpot touchedSpot) {
                const textStyle = TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                );
                return LineTooltipItem(
                  countDocGia[touchedSpot.spotIndex].toString(),
                  textStyle,
                );
              },
            ).toList();
          },
        ),
      ),
      gridData: FlGridData(
        drawHorizontalLine: false,
        drawVerticalLine: false,
      ),
    );
  }
}
