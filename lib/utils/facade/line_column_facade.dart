import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineColumnChartFacade {
  final List<dynamic> data;
  final String primaryXAxisTitle;
  final double interval;
  final double maximum;
  final Color columnColor;
  final Color lineColor;

  LineColumnChartFacade({
    required this.data,
    required this.primaryXAxisTitle,
    required this.interval,
    required this.maximum,
    required this.columnColor,
    required this.lineColor,
  });

  SfCartesianChart generateChart(TooltipBehavior tooltip) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(name: primaryXAxisTitle),
      primaryYAxis: NumericAxis(minimum: 0, maximum: maximum, interval: interval),
      tooltipBehavior: tooltip,
      series: <CartesianSeries<dynamic, dynamic>>[
        ColumnSeries<dynamic, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.x,
          yValueMapper: (datum, _) => datum.fine,
          name: 'Phạt',
          color: columnColor,
        ),
        LineSeries<dynamic, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum.x,
          yValueMapper: (datum, _) => datum.fee,
          name: 'Tạo thẻ',
          color: lineColor,
        ),
      ],
    );
  }
}
