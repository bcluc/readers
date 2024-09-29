import 'dart:math';

import 'package:flutter/material.dart';
import 'package:readers/main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:readers/models/report_thu_nhap.dart';

class BaoCaoThuNhap extends StatefulWidget {
  const BaoCaoThuNhap({required this.selectedYear, super.key});
  final int selectedYear;
  @override
  State<BaoCaoThuNhap> createState() => _BaoCaoThuNhapState();
}

class _ChartData {
  _ChartData(this.x, this.fine, this.fee);

  final String x;
  final int fine;
  final int fee;
}

class _BaoCaoThuNhapState extends State<BaoCaoThuNhap> {
  int _highestNum = 0;
  int _maxFine = 0;
  int _maxFee = 0;
  double _interval = 5;
  int _totalFine = 0;
  int _totalFee = 0;

  late List<TKThuNhap> _tienPhat;
  late List<TKThuNhap> _tienTaoThe;
  late TooltipBehavior _tooltip;
  late List<_ChartData> data;

  //màu chính và màu phụ
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  Color secondaryColor = const Color.fromARGB(255, 239, 71, 111);
  Color thirdColor = const Color.fromARGB(255, 255, 209, 102);
  Color bgColor = const Color.fromARGB(255, 229, 239, 243);
  Color toolTipColor = const Color.fromARGB(255, 72, 184, 233);

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  //Tính tổng tiền phạt theo 12 tháng trong năm
  //Truyền vào danh sách độc giả và năm được chọn
  List<int> _reportFineInYear(List<TKThuNhap> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKThuNhap tkPhieuPhat in list) {
      if (tkPhieuPhat.year == selectedYear) {
        reportList[tkPhieuPhat.month - 1] += tkPhieuPhat.price;
      }
    }
    _maxFine = reportList.reduce((curr, next) => curr > next ? curr : next);
    _highestNum = max(max(_maxFee, _maxFine), 10);
    _interval = _highestNum / 5;
    _totalFine = reportList.reduce((a, b) => a + b);

    return reportList;
  }

  //Tính tổng tiền tạo thẻ theo 12 tháng trong năm
  //Truyền vào danh sách độc giả và năm được chọn
  List<int> _reportFeeInYear(List<TKThuNhap> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKThuNhap tkTaoThe in list) {
      if (tkTaoThe.year == selectedYear) {
        reportList[tkTaoThe.month - 1] += tkTaoThe.price;
      }
    }
    _maxFee = reportList.reduce((curr, next) => curr > next ? curr : next);
    _highestNum = max(max(_maxFee, _maxFine), 10);
    _interval = _highestNum / 5;
    _totalFee = reportList.reduce((a, b) => a + b);
    return reportList;
  }

  late final Future<void> _listChartReaders = _getIncome();
  Future<void> _getIncome() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _tienPhat = await dbProcess.queryTienPhatTheoThang();
    _tienTaoThe = await dbProcess.queryTienTaoTheTheoThang();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _listChartReaders,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(50, 10, 70, 60),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    const Text(
                      'Doanh thu của thư viện',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const Spacer(),
                    const Text(
                      'Tiền phạt',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 50,
                      height: 24,
                      //color: mainColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: mainColor),
                          color: mainColor),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    const Text(
                      'Tiền tạo thẻ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 50,
                      height: 24,
                      //color: mainColor,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: secondaryColor),
                          color: secondaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(child: _chart()),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Tổng tiền phạt : $_totalFine',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Tổng tiền tạo thẻ : $_totalFee',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //
  // Dữ liệu cho chart Line
  //

  SfCartesianChart _chart() {
    data = getData();
    double maximum = _highestNum.toDouble();
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(name: "DOANH THU"),
        primaryYAxis:
            NumericAxis(minimum: 0, maximum: maximum, interval: _interval),
        tooltipBehavior: _tooltip,
        series: <ChartSeries<_ChartData, String>>[
          ColumnSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.fine,
              name: 'Phạt',
              color: mainColor),
          LineSeries<_ChartData, String>(
              dataSource: data,
              xValueMapper: (_ChartData data, _) => data.x,
              yValueMapper: (_ChartData data, _) => data.fee,
              name: 'Tạo thẻ',
              color: secondaryColor)
        ]);
  }

  List<_ChartData> getData() {
    final List<int> sumFine = _reportFineInYear(_tienPhat, widget.selectedYear);
    final List<int> sumFee = _reportFeeInYear(_tienTaoThe, widget.selectedYear);
    //final List<int> sumTotal = _reportIncomeInYear(sumFee, sumFine);
    List<_ChartData> report = [];
    for (int i = 0; i < 12; i++) {
      report.add(_ChartData("Th$i", sumFine[i], sumFee[i]));
    }
    return report;
  }

// Tạo viền và giá trị dưới
}
