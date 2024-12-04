import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartAxisFacade {
  FlTitlesData buildAxis(int topValue, String axisName) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            const months = [
              'Th1',
              'Th2',
              'Th3',
              'Th4',
              'Th5',
              'Th6',
              'Th7',
              'Th8',
              'Th9',
              'Th10',
              'Th11',
              'Th12'
            ];
            return Text(months[value.toInt() - 1]);
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: (topValue / 5).toDouble(),
          getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
        ),
        axisNameWidget: Text(axisName),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }
}
