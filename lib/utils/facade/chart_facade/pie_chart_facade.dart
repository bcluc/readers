import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartFacade {
  final Map<String, double> dataMap;

  PieChartFacade({required this.dataMap});

  Widget generatePieChart({
    required BuildContext context,
    double? chartRadius,
  }) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: chartRadius ?? MediaQuery.of(context).size.width / 3.2,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.normal,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 0,
        chartValueStyle: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.black,
        ),
      ),
    );
  }
}
