import 'package:flutter/material.dart';
import 'package:readers/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:readers/models/report_doc_gia.dart';
import 'package:readers/screens/report_manage/report_docgia_chitiet.dart';
import 'package:readers/utils/facade/line_chart_facade.dart';

class BaoCaoDocGia extends StatefulWidget {
  const BaoCaoDocGia({required this.selectedYear, super.key});
  final int selectedYear;
  @override
  State<BaoCaoDocGia> createState() => _BaoCaoDocGiaState();
}

class _BaoCaoDocGiaState extends State<BaoCaoDocGia> {
  int _highestNum = 0;
  int _totalReader = 0;
  late List<TKDocGia> _readers;

  //màu chính và màu phụ
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  Color secondaryColor = const Color.fromARGB(255, 229, 239, 243);
  Color thirdColor = const Color.fromARGB(255, 72, 184, 233);

  //Tính tổng độc giả theo 12 tháng trong năm
  //Truyền vào danh sách độc giả và năm được chọn
  List<int> _reportDocGiaInYear(List<TKDocGia> list, int selectedYear) {
    List<int> reportList = List<int>.filled(12, 0, growable: false);
    for (TKDocGia tkDocGia in list) {
      if (tkDocGia.year == selectedYear) {
        reportList[tkDocGia.month - 1]++;
      }
    }
    _totalReader = reportList.reduce((a, b) => a + b);
    _highestNum = reportList.reduce((curr, next) => curr > next ? curr : next);
    return reportList;
  }

  late final Future<void> _listChartReaders = _getDocGia();
  Future<void> _getDocGia() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _readers = await dbProcess.queryDocGiaTheoThang();
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

        final countDocGia = _reportDocGiaInYear(_readers, widget.selectedYear);

        final lineChartFacade = LineChartFacade(
          countDocGia: countDocGia,
          highestNum: _highestNum,
          mainColor: mainColor,
          secondaryColor: secondaryColor,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(50, 10, 70, 60),
          child: Column(
            children: <Widget>[
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'Số lượng các độc giả mới được thêm vào',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: LineChart(
                  lineChartFacade.generateChartData(
                    onSpotTap: (month) {
                      showDialog(
                        context: context,
                        builder: (ctx) => BaoCaoChiTietDocGia(
                          list: _docGiaListInMonth(month),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Tổng độc giả đăng ký : $_totalReader',
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

  // Danh sách chi tiết độc giả trong tháng
  List<TKDocGia> _docGiaListInMonth(int month) {
    List<TKDocGia> list = List.empty(growable: true);
    for (var element in _readers) {
      if (element.year == widget.selectedYear && element.month == (month + 1)) {
        list.add(element);
      }
    }
    return list;
  }
}
