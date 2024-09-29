import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:readers/main.dart';
import 'package:readers/models/report_sach.dart';
import 'package:readers/models/report_the_loai_muon.dart';
import 'package:readers/screens/report_manage/report_sach_chitiet.dart';
import 'package:readers/screens/report_manage/report_sach_muon_the_loai.dart';

class BaoCaoSach extends StatefulWidget {
  const BaoCaoSach({required this.selectedYear, super.key});
  final int selectedYear;
  @override
  State<BaoCaoSach> createState() => _BaoCaoSachState();
}

class _BaoCaoSachState extends State<BaoCaoSach> {
  int _highestNum = 0;
  int _totalBookBorrow = 0;
  int _totalBookImport = 0;
  final double _width = 35;
  late List<TKSach> _bookBorrow;
  late List<TKSach> _bookImport;
  late List<TKTheLoai> _bookCategory;

  //var _selectedYear = DateTime.now();
  var isHoverYearBtn = false;
  //màu chính và màu phụ
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  Color secondaryColor = const Color.fromARGB(255, 229, 239, 243);
  Color thirdColor = const Color.fromARGB(255, 72, 184, 233);

  List<int> _reportSachMuonInYear(List<TKSach> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKSach tkSachMuon in list) {
      if (tkSachMuon.year == selectedYear) {
        reportList[tkSachMuon.month - 1]++;
      }
    }
    _highestNum = max(_highestNum,
        reportList.reduce((curr, next) => curr > next ? curr : next));
    _totalBookBorrow = reportList.reduce((a, b) => a + b);
    return reportList;
  }

  List<int> _reportSachNhapInYear(List<TKSach> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKSach tkSachNhap in list) {
      if (tkSachNhap.year == selectedYear) {
        reportList[tkSachNhap.month - 1]++;
      }
    }
    _highestNum = max(_highestNum,
        reportList.reduce((curr, next) => curr > next ? curr : next));
    _totalBookImport = reportList.reduce((a, b) => a + b);
    return reportList;
  }

  late final Future<void> _listBook = _getSach();
  Future<void> _getSach() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _bookBorrow = await dbProcess.querySachMuonTheoThang();
    _bookImport = await dbProcess.querySachNhapTheoThang();
    _bookCategory = await dbProcess.queryTheLoaiSachMuonTheoNam();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listBook,
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
                        'Số lượng sách nhập và sách mượn',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Spacer(),
                      const Text(
                        'Sách mượn',
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
                        'Sách nhập',
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
                            border: Border.all(color: thirdColor),
                            color: thirdColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(child: BarChart(_mainBarData())),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          'Tổng sách mượn : $_totalBookBorrow',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 7,
                          width: 7,
                        ),
                        Text(
                          'Tổng sách nhập : $_totalBookImport',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onHover: (value) => {isHoverYearBtn = true},
                      onPressed: //() {},
                          () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BaoCaoTheLoaiSachMuon(
                              selectedYear: widget.selectedYear,
                              list: _bookCategory,
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        foregroundColor: Colors.white.withOpacity(0.5),
                        minimumSize: const Size(100, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),
                      child: const Text(
                        "Chi tiết thể loại sách mượn",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  BarChartData _mainBarData() {
    int topValue = _highestNum - _highestNum % 10 + 10;
    return BarChartData(
        minY: 0,
        maxY: topValue.toDouble(),
        titlesData: _buildAxes(),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(tooltipBgColor: secondaryColor),
          touchCallback: (p0, p1) {
            if (p0 is FlTapUpEvent) {
              if (p1 == null) return;
              if (p1.spot?.touchedBarGroupIndex == null) return;
              if (p1.spot?.touchedRodDataIndex == null) return;
              showDialog(
                context: context,
                builder: (ctx) => BaoCaoSachChiTiet(
                  barIndex: p1.spot!.touchedRodDataIndex,
                  list: _bookListInMoth(p1.spot!.touchedBarGroupIndex,
                      p1.spot!.touchedRodDataIndex),
                ),
              );
            }
          },
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(
            border: const Border(
                bottom: BorderSide(width: 1), left: BorderSide(width: 1))),
        barGroups: _buildAllBars());
  }

  // tạo các mục dưới bảng
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Th1';
              break;
            case 2:
              text = 'Th2';
              break;
            case 3:
              text = 'Th3';
              break;
            case 4:
              text = 'Th4';
              break;
            case 5:
              text = 'Th5';
              break;
            case 6:
              text = 'Th6';
              break;
            case 7:
              text = 'Th7';
              break;
            case 8:
              text = 'Th8';
              break;
            case 9:
              text = 'Th9';
              break;
            case 10:
              text = 'Th10';
              break;
            case 11:
              text = 'Th11';
              break;
            case 12:
              text = 'Th12';
              break;
          }

          return Text(text);
        },
      );

// Tạo title cho khung
  FlTitlesData _buildAxes() {
    int topValue = _highestNum - _highestNum % 10 + 10;

    return FlTitlesData(
        show: true,
        // Build X axis.
        bottomTitles: AxisTitles(sideTitles: _bottomTitles),
        leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: defaultGetTitle,
              reservedSize: 30,
              interval: (topValue / 5).toDouble(),
            ),
            axisNameWidget: const Text('CUỐN SÁCH')),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)));
  }

  // Tạo cả 2 biểu đồ sách mượn và sách nhập
  List<BarChartGroupData> _buildAllBars() {
    final List<int> bookBorrowList =
        _reportSachMuonInYear(_bookBorrow, widget.selectedYear);
    final List<int> bookImportList =
        _reportSachNhapInYear(_bookImport, widget.selectedYear);
    return List.generate(
      bookBorrowList.length, // y1                 // y2
      (index) => _buildBar(index, bookBorrowList[index].toDouble(),
          bookImportList[index].toDouble()),
    );
  }

  // Function to define how to bar would look like.
  BarChartGroupData _buildBar(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 5,
      x: x + 1,
      barRods: [
        BarChartRodData(
            toY: y1,
            color: mainColor,
            width: _width,
            borderRadius: BorderRadius.circular(3)),
        BarChartRodData(
            toY: y2,
            color: thirdColor,
            width: _width,
            borderRadius: BorderRadius.circular(3)),
      ],
    );
  }

  // Danh sách chi tiết các sách mượn trong tháng
  List<TKSach> _bookBorrowListInMonth(int month) {
    List<TKSach> list = List.empty(growable: true);
    for (var element in _bookBorrow) {
      if (element.year == widget.selectedYear && element.month == (month + 1)) {
        list.add(element);
      }
    }
    return list;
  }

  // Danh sách chi tiết các sách nhập trong tháng
  List<TKSach> _bookImportListInMonth(int month) {
    List<TKSach> list = List.empty(growable: true);
    for (var element in _bookImport) {
      if (element.year == widget.selectedYear && element.month == (month + 1)) {
        list.add(element);
      }
    }
    return list;
  }

  // Trả về danh sách loại sách trong tháng
  List<TKSach> _bookListInMoth(int month, int barIndex) {
    List<TKSach> list = List.empty(growable: true);
    if (barIndex == 0) {
      list = _bookBorrowListInMonth(month);
    } else {
      list = _bookImportListInMonth(month);
    }
    return list;
  }
}
