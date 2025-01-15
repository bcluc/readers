import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/components/label_text_form_field_datepicker.dart';
import 'package:readers/features/sach_management/cubit/sach_management_cubit.dart';
import 'package:readers/main.dart';
import 'package:readers/models/chi_tiet_phieu_nhap.dart';
import 'package:readers/models/phieu_nhap.dart';
import 'package:readers/screens/book_manage/book_manage.dart';
import 'package:readers/screens/book_manage/nhap_sach/add_edit_enter_book_detail_form.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

extension NhapSach on BookManageState {
  Widget buildNhapSach() {
    final dateAddedController = TextEditingController(
      text: DateTime.now().toVnFormat(),
    );

    int totalAmout = 0;
    final totalAmountController = TextEditingController(text: '0');

    List<ChiTietPhieuNhap> chiTietPhieuNhaps = [];
    int selectedRow = -1;

    bool isProcessing = false;

    Future<void> savePhieuNhap(
        Function(void Function()) setStateNhapSach) async {
      setStateNhapSach(() {
        isProcessing = true;
      });

      int maPhieuNhap = await dbProcess.insertPhieuNhap(
        PhieuNhap(
          null,
          vnDateFormat.parse(dateAddedController.text),
          totalAmout,
        ),
      );

      for (var chiTietPhieuNhap in chiTietPhieuNhaps) {
        chiTietPhieuNhap.maPhieuNhap = maPhieuNhap;
        dbProcess.insertChiTietPhieuNhap(chiTietPhieuNhap);
      }

      setStateNhapSach(() {
        totalAmout = 0;
        totalAmountController.text = '0';
        chiTietPhieuNhaps.clear();
        isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tạo Phiếu Nhập sách thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 350,
            action: SnackBarAction(
              label: 'Xem',
              onPressed: () => tabController.animateTo(3),
            ),
          ),
        );
      }
    }

    Future<void> logicEditChiTietPhieuNhap(
        Function(void Function()) setStateNhapSach) async {
      String? message = await showDialog(
        context: context,
        builder: (ctx) => AddEditEnterBookDetailForm(
          editChiTietNhapSach: chiTietPhieuNhaps[selectedRow],
          danhSachChiTietPhieuNhapDaThem: chiTietPhieuNhaps,
        ),
      );

      if (message == "updated") {
        setStateNhapSach(() {});
      }
    }

    Future<String> getTenDauSach(int maSach) async {
      final sachs = context.read<SachManagementCubit>().state.sachs;
      if (sachs != null) {
        await context.read<SachManagementCubit>().getTenDauSach(maSach, sachs);
        return context.read<SachManagementCubit>().state.tenDauSach;
      } else {
        return '';
      }
    }

    return StatefulBuilder(
      builder: (ctx, setStateNhapSach) => Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: LabelTextFieldDatePicker(
                      labelText: 'Ngày nhập',
                      controller: dateAddedController,
                    ),
                  ),
                  const SizedBox(width: 50),
                  /* Tổng tiền */
                  Expanded(
                    child: LabelTextFormField(
                      labelText: 'Tổng tiền:',
                      controller: totalAmountController,
                      isEnable: false,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton.filled(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) {
                          return AddEditEnterBookDetailForm(
                            danhSachChiTietPhieuNhapDaThem: chiTietPhieuNhaps,
                            onAddChiTietPhieuNhap: (newChiTietPhieuNhap) {
                              setStateNhapSach(
                                () {
                                  totalAmout += newChiTietPhieuNhap.tongTien;
                                  totalAmountController.text =
                                      totalAmout.toVnCurrencyFormat();
                                  chiTietPhieuNhaps.add(newChiTietPhieuNhap);
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.add_rounded),
                    style: myIconButtonStyle,
                  ),
                  const SizedBox(width: 12),
                  /* 
                  */
                  IconButton.filled(
                    onPressed: selectedRow == -1
                        ? null
                        : () async {
                            setStateNhapSach(() {
                              // Cập nhật lại tổng số tiền nhập sách trước khi xóa
                              totalAmout -=
                                  chiTietPhieuNhaps[selectedRow].tongTien;
                              totalAmountController.text =
                                  totalAmout.toVnCurrencyFormat();
                              // Xóa
                              chiTietPhieuNhaps.removeAt(selectedRow);
                              // Nếu SelectedRow nằm ngoài phạm vi của chiTietPhieuNhaps
                              // thì phải set lại bằng -1 để tránh lỗi
                              if (selectedRow >= chiTietPhieuNhaps.length) {
                                selectedRow = -1;
                              }
                            });
                          },
                    icon: const Icon(Icons.delete),
                    style: myIconButtonStyle,
                  ),
                  const SizedBox(width: 12),
                  /* 
                  Edit Chi tiết nhập sách
                  */
                  IconButton.filled(
                    onPressed: selectedRow == -1
                        ? null
                        : () {
                            logicEditChiTietPhieuNhap(setStateNhapSach);
                          },
                    icon: const Icon(Icons.edit),
                    style: myIconButtonStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            Expanded(
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Số lượng',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Đơn giá',
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
                        child: ListView(
                          children: List.generate(
                            chiTietPhieuNhaps.length,
                            (index) {
                              return Column(
                                children: [
                                  Ink(
                                    color: selectedRow == index
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1)
                                        : null,
                                    child: InkWell(
                                      onTap: () {
                                        setStateNhapSach(
                                          () => selectedRow = index,
                                        );
                                      },
                                      onLongPress: () {
                                        setStateNhapSach(
                                          () => selectedRow = index,
                                        );
                                        logicEditChiTietPhieuNhap(
                                            setStateNhapSach);
                                      },
                                      child: Row(
                                        children: [
                                          const Gap(30),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              (index + 1).toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: FutureBuilder<String>(
                                                future: getTenDauSach(
                                                  chiTietPhieuNhaps[index]
                                                      .maSach,
                                                ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Text('Error');
                                                  } else {
                                                    return Text(snapshot.data
                                                            ?.capitalizeFirstLetterOfEachWord() ??
                                                        '');
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                chiTietPhieuNhaps[index]
                                                    .maSach
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                  chiTietPhieuNhaps[index]
                                                      .soLuong
                                                      .toString()),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      chiTietPhieuNhaps[index]
                                                          .donGia
                                                          .toVnCurrencyWithoutSymbolFormat(),
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  if (selectedRow == index)
                                                    Icon(
                                                      Icons.check,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Gap(30),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < chiTietPhieuNhaps.length - 1)
                                    const Divider(
                                      height: 0,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: isProcessing
                    ? const SizedBox(
                        width: 91,
                        child: Center(
                          child: SizedBox(
                            height: 44,
                            width: 44,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        ),
                      )
                    : FilledButton(
                        onPressed: () => savePhieuNhap(setStateNhapSach),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 30,
                          ),
                        ),
                        child: const Text(
                          'Save',
                          textAlign: TextAlign.center,
                        ),
                      ),
              ),
            ],
          )),
    );
  }
}
