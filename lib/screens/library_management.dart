import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/doi_ma_pin.dart';
import 'package:readers/components/doi_mat_khau_dialog.dart';
import 'package:readers/components/khoa_man_hinh_dialog.dart';
import 'package:readers/screens/book_manage/book_manage.dart';
import 'package:readers/screens/borrow_return/borrow_return.dart';
import 'package:readers/screens/reader_manage/reader_manage.dart';
import 'package:readers/screens/regulations/regulations.dart';
import 'package:readers/screens/report_manage/report_manage.dart';

class LibraryManagement extends StatefulWidget {
  const LibraryManagement({super.key});

  @override
  State<LibraryManagement> createState() => _LibraryManagementState();
}

class _LibraryManagementState extends State<LibraryManagement>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var windowButtonColors = WindowButtonColors(
      mouseOver: Theme.of(context).colorScheme.primary,
    );
    return Scaffold(
      body: Column(
        children: [
          Ink(
            color: Theme.of(context).colorScheme.background,
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Color.fromARGB(255, 175, 219, 208), Color.fromARGB(255, 236, 237, 182)],
            //   ),
            // ),
            child: Column(
              children: [
                WindowTitleBarBox(
                  child: Row(
                    children: [
                      Expanded(
                        child: MoveWindow(),
                      ),
                      MinimizeWindowButton(colors: windowButtonColors),
                      MaximizeWindowButton(colors: windowButtonColors),
                      CloseWindowButton(),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Gap(30),
                    Image.asset(
                      'assets/logo/Asset_1.png',
                      width: 44,
                    ),
                    const Gap(20),
                    SvgPicture.asset(
                      'assets/LibraryBOOKS.svg',
                      width: 160,
                    ),
                    const Gap(70),
                    Expanded(
                      child: TabBar(
                        controller: _tabController,
                        labelStyle: const TextStyle(fontSize: 16),
                        tabs: const [
                          Tab(
                            text: "Độc giả",
                            height: 60,
                          ),
                          Tab(
                            text: "Quản lý Sách",
                            height: 60,
                          ),
                          Tab(
                            text: "Mượn trả",
                            height: 60,
                          ),
                          Tab(
                            text: "Báo cáo",
                            height: 60,
                          ),
                          Tab(
                            text: "Quy định",
                            height: 60,
                          ),
                        ],
                        indicator: BoxDecoration(
                          // color: Colors.white,
                          // borderRadius: BorderRadius.vertical(
                          //   top: Radius.circular(8),
                          // ),
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashBorderRadius: BorderRadius.circular(8),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        overlayColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2);
                          }
                          if (states.contains(MaterialState.pressed)) {
                            return Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2);
                          }
                          return Colors.transparent;
                        }),
                        labelColor: Colors.white,
                      ),
                    ),
                    const Gap(70),
                    PopupMenuButton(
                      icon: const Image(
                        image: AssetImage('assets/profile-user.png'),
                        width: 32,
                      ),
                      position: PopupMenuPosition.under,
                      offset: const Offset(0, 8),
                      itemBuilder: (ctx) => <PopupMenuEntry>[
                        PopupMenuItem(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => const KhoaManHinhDialog(),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.lock_rounded),
                              Gap(12),
                              Text('Khóa màn hình'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => const DoiMatKhauDialog(),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.password_rounded),
                              Gap(12),
                              Text('Đổi mật khẩu'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => const DoiMaPin(),
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.pin),
                              Gap(12),
                              Text('Đổi mã PIN'),
                            ],
                          ),
                        ),
                      ],
                      surfaceTintColor: Colors.transparent,
                      tooltip: '',
                    ),
                    const Gap(30),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const ReaderManage(),
                const BookManage(),
                const BorrowReturn(),
                const ReportManage(),
                Regulations(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
