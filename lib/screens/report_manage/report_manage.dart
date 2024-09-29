import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:readers/screens/report_manage/report_docgia.dart';
import 'package:readers/screens/report_manage/report_sach.dart';
import 'package:readers/screens/report_manage/report_thu_nhap.dart';

class ReportManage extends StatefulWidget {
  const ReportManage({super.key});

  @override
  State<ReportManage> createState() => _ReportManageState();
}

class _ReportManageState extends State<ReportManage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  //late final ScrollController _scrollController;
  final int _count = 3;
  //bool fixedScroll = true;
  var _selectedYear = DateTime.now();
  Color mainColor = const Color.fromARGB(255, 4, 104, 138);
  var isHoverYearBtn = false;
  //String showYear = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _count, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
                child: Ink(
                  width: 400,
                  padding: EdgeInsets.all(_count.toDouble()),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: TabBar(
                    indicatorPadding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "Độc giả"),
                      Tab(text: "Sách"),
                      Tab(text: "Doanh thu"),
                    ],
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    splashBorderRadius: BorderRadius.circular(8),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                    unselectedLabelColor: Colors.white,
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white.withOpacity(0.3);
                      }
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white.withOpacity(0.5);
                      }
                      return Colors.transparent;
                    }),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onHover: (value) => {isHoverYearBtn = true},
                onPressed: //() {},
                    () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Select Year"),
                        content: SizedBox(
                          width: 300,
                          height: 300,
                          child: YearPicker(
                            firstDate: DateTime(1940),
                            // lastDate: DateTime.now(),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                            selectedDate: _selectedYear,
                            onChanged: (DateTime dateTime) {
                              setState(() {
                                _selectedYear = dateTime;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ),
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
                child: Text(
                  _selectedYear.getYear.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 30)
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                BaoCaoDocGia(
                  selectedYear: _selectedYear.year,
                ),
                BaoCaoSach(
                  selectedYear: _selectedYear.year,
                ),
                BaoCaoThuNhap(
                  selectedYear: _selectedYear.year,
                ),
                // BaoCaoDoanhThu(
                //   selectedYear: _selectedYear.year,
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
