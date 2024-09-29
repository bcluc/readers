import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/utils/extension.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:readers/models/report_the_loai_muon.dart';

class BaoCaoTheLoaiSachMuon extends StatelessWidget {
  const BaoCaoTheLoaiSachMuon(
      {required this.selectedYear, required this.list, super.key});

  final int selectedYear;
  // Tổng số sách
  final List<TKTheLoai> list;

  Map<String, double>? _reportTLSachMuonInYear(
      List<TKTheLoai> llist, int selectedYearr) {
    Map<String, double>? emptyList;
    for (TKTheLoai tkTLSachMuon in llist) {
      if (tkTLSachMuon.year == selectedYearr) {
        emptyList = emptyList ?? {};
        emptyList[tkTLSachMuon.theLoai.capitalizeFirstLetter()] =
            tkTLSachMuon.quanity.toDouble();
      }
    }
    return emptyList;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double>? reportList =
        _reportTLSachMuonInYear(list, selectedYear);
    Map<String, double> finalList;
    if (reportList == null) {
      return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Không có cuốn sách nào được mượn',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
              )));
    } else {
      finalList = reportList;
      return Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Biểu đồ các thể loại trong sách mượn',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 70, 60),
                  child: Center(
                    child: PieChart(
                      dataMap: finalList,
                      animationDuration: const Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
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
                              color: Colors.black)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
