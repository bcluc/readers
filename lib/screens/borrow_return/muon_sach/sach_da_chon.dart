import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/inform_dialog.dart';
import 'package:readers/cubit/selected_cuon_sach_cho_muon.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/main.dart';
import 'package:readers/models/observers/book_borrow_observer.dart';
import 'package:readers/models/observers/concrete_book_observers.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';

class SachDaChon extends StatefulWidget {
  const SachDaChon(
    this.maCuonSachToAddCuonSachController, {
    super.key,
    required this.soSachCoTheMuon,
  });

  final TextEditingController maCuonSachToAddCuonSachController;
  final int soSachCoTheMuon;

  @override
  State<SachDaChon> createState() => _SachDaChonState();
}

class _SachDaChonState extends State<SachDaChon> {
  late final UIBookObserver _uiObserver;
  late final DatabaseBookObserver _dbObserver;
  late final StatisticsBookObserver _statsObserver;
  final _bookBorrowSubject = BookBorrowSubject();

  @override
  void initState() {
    super.initState();
    // Initialize observers
    _uiObserver = UIBookObserver(context);
    _dbObserver = DatabaseBookObserver();
    _statsObserver = StatisticsBookObserver();

    // Add observers to subject
    _bookBorrowSubject.addObserver(_uiObserver);
    _bookBorrowSubject.addObserver(_dbObserver);
    _bookBorrowSubject.addObserver(_statsObserver);
  }

  @override
  void dispose() {
    // Remove observers when widget is disposed
    _bookBorrowSubject.removeObserver(_uiObserver);
    _bookBorrowSubject.removeObserver(_dbObserver);
    _bookBorrowSubject.removeObserver(_statsObserver);
    super.dispose();
  }

  void _addCuonSachWithMaCuonSach(BuildContext context) async {
    /* Kiểm tra đã nhập Mã Độc giả chưa */
    if (widget.soSachCoTheMuon == ThamSoQuyDinh.soSachMuonToiDa + 1) {
      showDialog(
        context: context,
        builder: (ctx) => const InformDialog(
          content: 'Chưa có thông tin Độc giả.',
        ),
      );
      return;
    }

    /* Kiểm tra còn có thể mượn thêm sách không */
    if (context.read<SelectedCuonSachChoMuonCubit>().state.length ==
        widget.soSachCoTheMuon) {
      showDialog(
        context: context,
        builder: (ctx) => InformDialog(
          content:
              'Độc giả này chỉ có thể mượn thêm tối đa ${widget.soSachCoTheMuon} cuốn sách!',
        ),
      );
      return;
    }

    String maCuonSach = widget.maCuonSachToAddCuonSachController.text.trim();
    if (maCuonSach.isEmpty) return;

    final isSelected = context
        .read<SelectedCuonSachChoMuonCubit>()
        .containMaCuonSach(maCuonSach);
    if (isSelected) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cuốn sách $maCuonSach này đã được chọn rồi',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          width: 300,
        ),
      );
      return;
    }

    CuonSachDto2th? cuonSach =
        await dbProcess.queryCuonSachDto2thSanCoWithMaCuonSach(maCuonSach);
    if (cuonSach == null) {
      showDialog(
        context: context,
        builder: (ctx) => const InformDialog(
          content: 'Không tìm thấy cuốn sách hoặc cuốn sách đã được mượn!',
        ),
      );
    } else {
      // Notify observers about book being borrowed
      _bookBorrowSubject.notifyBookBorrowed(
        cuonSach.maCuonSach.toString(),
        cuonSach.tenDauSach,
      );
      _bookBorrowSubject.notifyBookStatusChanged(
        cuonSach.maCuonSach.toString(),
        "Đang mượn",
      );

      context.read<SelectedCuonSachChoMuonCubit>().add(cuonSach);
      widget.maCuonSachToAddCuonSachController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SÁCH ĐÃ CHỌN',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(4),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.maCuonSachToAddCuonSachController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.add_rounded),
                  ),
                  prefixIconColor: const Color.fromARGB(255, 81, 81, 81),
                  hintText: 'Nhập mã Cuốn sách muốn thêm',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 81, 81, 81),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.all(14),
                ),
                onEditingComplete: () => _addCuonSachWithMaCuonSach(context),
              ),
            ),
            const Gap(12),
            FilledButton(
              onPressed: () => _addCuonSachWithMaCuonSach(context),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 36),
              ),
              child: const Icon(Icons.add_rounded),
            )
          ],
        ),
        const Gap(10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 15),
                          child: Text(
                            'Mã CS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Tên Đầu sách',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Mã Sách',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 20),
                          child: Text(
                            'Tác giả',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<SelectedCuonSachChoMuonCubit, List<CuonSachDto2th>>(
                  builder: (ctx, selectedCuonSach) {
                    return Expanded(
                      child: selectedCuonSach.isEmpty
                          ? const Center(
                              child: Text('Danh sách rỗng'),
                            )
                          : ListView(
                              children: List.generate(selectedCuonSach.length,
                                  (index) {
                                bool isMaCuonSachHover = false;
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 120,
                                          child: StatefulBuilder(
                                            builder:
                                                (ctx, setStateSoLuongInkWell) {
                                              return InkWell(
                                                onTap: () {
                                                  context
                                                      .read<
                                                          SelectedCuonSachChoMuonCubit>()
                                                      .remove(
                                                        selectedCuonSach[index],
                                                      );
                                                },
                                                onHover: (value) =>
                                                    setStateSoLuongInkWell(
                                                  () =>
                                                      isMaCuonSachHover = value,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 15, 15, 15),
                                                  child: SizedBox(
                                                    height: 24,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            selectedCuonSach[
                                                                    index]
                                                                .maCuonSach
                                                                .toString(),
                                                          ),
                                                        ),
                                                        if (isMaCuonSachHover)
                                                          const Icon(
                                                            Icons.remove,
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Text(
                                              selectedCuonSach[index]
                                                  .tenDauSach
                                                  .capitalizeFirstLetterOfEachWord(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Text(
                                              selectedCuonSach[index]
                                                  .maSach
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15, right: 20),
                                            child: Text(
                                              selectedCuonSach[index]
                                                  .tacGiasToString(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (index < selectedCuonSach.length - 1)
                                      const Divider(
                                        height: 0,
                                      ),
                                  ],
                                );
                              }),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
