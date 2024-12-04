import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/models/report_the_loai_muon.dart';
import 'package:readers/utils/facade/pie_chart_facade.dart';

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

    if (reportList == null) {
      return _buildNoDataDialog(context);
    } else {
      final pieChartFacade = PieChartFacade(dataMap: reportList);
      return _buildPieChartDialog(context, pieChartFacade);
    }
  }

  Widget _buildNoDataDialog(BuildContext context) {
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChartDialog(
      BuildContext context, PieChartFacade pieChartFacade) {
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
                  child: pieChartFacade.generatePieChart(
                    context: context,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
