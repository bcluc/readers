import 'package:flutter/material.dart';
import 'package:readers/screens/book_manage/kho_sach/kho_sach.dart';
import 'package:readers/screens/book_manage/nhap_sach/nhap_sach.dart';
import 'package:readers/screens/book_manage/quan_ly_dau_sach/quan_ly_dau_sach.dart';
import 'package:readers/screens/book_manage/quan_ly_phieu_nhap/quan_ly_phieu_nhap.dart';
import 'package:readers/screens/book_manage/quan_ly_tac_gia/quan_ly_tac_gia.dart';
import 'package:readers/screens/book_manage/quan_ly_the_loai/quan_ly_the_loai.dart';

class BookManage extends StatefulWidget {
  const BookManage({super.key});

  @override
  State<BookManage> createState() => BookManageState();
}

class BookManageState extends State<BookManage> with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 25, 30, 20),
            child: Ink(
              width: 750,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: TabBar(
                indicatorPadding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 6,
                ),
                controller: tabController,
                tabs: const [
                  Tab(text: "Kho sách"),
                  Tab(text: 'Đầu sách'),
                  Tab(text: "Nhập sách"),
                  Tab(text: "Phiếu nhập"),
                  Tab(text: "Tác giả"),
                  Tab(text: "Thể loại"),
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
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                const KhoSach(),
                const QuanLyDauSach(),
                buildNhapSach(),
                const QuanLyPhieuNhap(),
                const QuanLyTacGia(),
                const QuanLyTheLoai(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
