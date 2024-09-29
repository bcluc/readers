import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/cubit/selected_cuon_sach_cho_muon.dart';
import 'package:readers/screens/borrow_return/muon_sach/muon_sach.dart';
import 'package:readers/screens/borrow_return/quan_ly_muon_tra/quan_ly_muon_tra.dart';
import 'package:readers/screens/borrow_return/tra_sach/tra_sach.dart';

class BorrowReturn extends StatefulWidget {
  const BorrowReturn({super.key});

  @override
  State<BorrowReturn> createState() => _BorrowReturnState();
}

class _BorrowReturnState extends State<BorrowReturn>
    with TickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
              width: 480,
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
                  Tab(text: "Cho mượn sách"),
                  Tab(text: "Nhận trả sách"),
                  Tab(text: "Phiếu Mượn/Trả"),
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
                BlocProvider(
                  create: (_) => SelectedCuonSachChoMuonCubit(),
                  child: const MuonSach(),
                ),
                const TraSach(),
                const QuanLyMuonTra(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
