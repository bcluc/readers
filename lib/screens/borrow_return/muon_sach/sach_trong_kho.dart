import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/inform_dialog.dart';
import 'package:readers/cubit/selected_cuon_sach_cho_muon.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/borrow_return/muon_sach/chi_tiet_thong_tin_cuon_sach.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';

class SachTrongKho extends StatefulWidget {
  const SachTrongKho(
    this.searchCuonSachController, {
    super.key,
    required this.soSachCoTheMuon,
  });

  final TextEditingController searchCuonSachController;
  final int soSachCoTheMuon;

  @override
  State<SachTrongKho> createState() => _SachTrongKhoState();
}

class _SachTrongKhoState extends State<SachTrongKho> {
  List<CuonSachDto2th> _cuonSachs = [];

  void _searchCuonSachTrongKho() async {
    final tuKhoa = widget.searchCuonSachController.text.toLowerCase().trim();
    if (tuKhoa.isEmpty) {
      return;
    }

    _cuonSachs = await dbProcess.queryCuonSachDto2thSanCoWithKeyword(tuKhoa);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant SachTrongKho oldWidget) {
    // print('searchCuonSachController: ${widget.searchCuonSachController.text}');
    if (widget.searchCuonSachController.text.isEmpty) {
      /* 
      The framework always calls [build] after calling [didUpdateWidget], 
      which means any calls to [setState] in [didUpdateWidget] are redundant. 
      */
      _cuonSachs.clear();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.searchCuonSachController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SÁCH TRONG KHO',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(4),
        /* SEARCH CUÔN SÁCH BAR */
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.searchCuonSachController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.search_rounded),
                  ),
                  prefixIconColor: const Color.fromARGB(255, 81, 81, 81),
                  hintText: 'Tìm kiếm cuốn sách',
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
                onEditingComplete: _searchCuonSachTrongKho,
                onChanged: (value) async {
                  if (value.isEmpty) {
                    await Future.delayed(
                      const Duration(milliseconds: 50),
                    );
                    setState(() {
                      _cuonSachs.clear();
                    });
                  }
                },
              ),
            ),
            const Gap(12),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 36),
              ),
              child: const Icon(Icons.search_rounded),
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
                Expanded(
                  child: _cuonSachs.isEmpty
                      ? const Center(
                          child: Text('Chưa tìm thấy dữ liệu'),
                        )
                      : ListView(
                          children: List.generate(_cuonSachs.length, (index) {
                            bool isMaCuonSachHover = false;
                            bool isTenDauSachHover = false;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: StatefulBuilder(
                                        builder: (ctx, setStateSoLuongInkWell) {
                                          return InkWell(
                                            onTap: () {
                                              /* Kiểm tra đã nhập Mã Độc giả chưa */
                                              if (widget.soSachCoTheMuon ==
                                                  ThamSoQuyDinh
                                                          .soSachMuonToiDa +
                                                      1) {
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      const InformDialog(
                                                    content:
                                                        'Chưa có thông tin Độc giả.',
                                                  ),
                                                );
                                                return;
                                              }
                                              if (context
                                                      .read<
                                                          SelectedCuonSachChoMuonCubit>()
                                                      .state
                                                      .length ==
                                                  widget.soSachCoTheMuon) {
                                                /* Hiện thông báo đã mượn đủ số lượng quy định */
                                                showDialog(
                                                  context: context,
                                                  builder: (ctx) =>
                                                      InformDialog(
                                                    content:
                                                        'Độc giả này chỉ có thể mượn thêm tối đa ${widget.soSachCoTheMuon} cuốn sách!',
                                                  ),
                                                );
                                                return;
                                              }
                                              final isSelected = context
                                                  .read<
                                                      SelectedCuonSachChoMuonCubit>()
                                                  .contain(_cuonSachs[index]);
                                              if (!isSelected) {
                                                context
                                                    .read<
                                                        SelectedCuonSachChoMuonCubit>()
                                                    .add(
                                                      _cuonSachs[index],
                                                    );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'Cuốn sách ${_cuonSachs[index].maCuonSach} này đã được chọn rồi',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    duration: const Duration(
                                                        seconds: 3),
                                                    width: 300,
                                                  ),
                                                );
                                              }
                                            },
                                            onHover: (value) =>
                                                setStateSoLuongInkWell(
                                              () => isMaCuonSachHover = value,
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
                                                        _cuonSachs[index]
                                                            .maCuonSach
                                                            .toString(),
                                                      ),
                                                    ),
                                                    if (isMaCuonSachHover)
                                                      const Icon(
                                                        Icons.add_rounded,
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
                                      child: StatefulBuilder(
                                        builder:
                                            (ctx, setStateTenDauSachInkWell) {
                                          return InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    ChiTietThongTinCuonSach(
                                                  cuonSach: _cuonSachs[index],
                                                ),
                                              );
                                            },
                                            onHover: (value) =>
                                                setStateTenDauSachInkWell(
                                              () => isTenDauSachHover = value,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _cuonSachs[index]
                                                          .tenDauSach
                                                          .capitalizeFirstLetterOfEachWord(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  if (isTenDauSachHover)
                                                    const Icon(
                                                      Icons.open_in_new_rounded,
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Text(
                                          _cuonSachs[index].maSach.toString(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 20),
                                        child: Text(
                                          _cuonSachs[index].tacGiasToString(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (index < _cuonSachs.length - 1)
                                  const Divider(
                                    height: 0,
                                  ),
                              ],
                            );
                          }),
                        ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
