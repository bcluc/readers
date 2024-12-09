import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:readers/main.dart';
import 'package:readers/models/report_sach.dart';
import 'package:readers/models/report_the_loai_muon.dart';
import 'package:readers/screens/report_manage/report_sach_chitiet.dart';
import 'package:readers/screens/report_manage/report_sach_muon_the_loai.dart';
import 'package:readers/utils/facade/chart_facade/bar_chart_facade.dart';
import 'package:readers/utils/facade/chart_facade/chart_axis_facade.dart';

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
          final bookBorrowList =
              _reportSachMuonInYear(_bookBorrow, widget.selectedYear);
          final bookImportList =
              _reportSachNhapInYear(_bookImport, widget.selectedYear);
          final barChartFacade = BarChartFacade(
            highestNum: _highestNum,
            mainColor: const Color.fromARGB(255, 4, 104, 138),
            thirdColor: const Color.fromARGB(255, 72, 184, 233),
            width: 35,
          );

          final chartAxisFacade = ChartAxisFacade();
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
                          color: barChartFacade.mainColor,
                        ),
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
                            color: barChartFacade.thirdColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: BarChart(
                    barChartFacade.generateChartData(
                      bookBorrowList: bookBorrowList,
                      bookImportList: bookImportList,
                      titlesData: chartAxisFacade.buildAxis(
                        _highestNum - _highestNum % 10 + 10,
                        "CUỐN SÁCH",
                      ),
                      onBarTap: (month, barIndex) {
                        showDialog(
                          context: context,
                          builder: (ctx) => BaoCaoSachChiTiet(
                            barIndex: barIndex,
                            list: _bookListInMonth(month, barIndex),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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
  List<TKSach> _bookListInMonth(int month, int barIndex) {
    List<TKSach> list = List.empty(growable: true);
    if (barIndex == 0) {
      list = _bookBorrowListInMonth(month);
    } else {
      list = _bookImportListInMonth(month);
    }
    return list;
  }
}
