import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/features/sach_management/cubit/sach_management_cubit.dart';
import 'package:readers/models/chi_tiet_phieu_nhap.dart';
import 'package:readers/models/sach.dart';
import 'package:readers/screens/book_manage/nhap_sach/tat_ca_sach.dart';
import 'package:readers/screens/book_manage/nhap_sach/them_sach_moi_form.dart';
import 'package:readers/utils/extension.dart';

class AddEditEnterBookDetailForm extends StatefulWidget {
  const AddEditEnterBookDetailForm({
    super.key,
    this.danhSachChiTietPhieuNhapDaThem,
    this.onAddChiTietPhieuNhap,
    this.editChiTietNhapSach,
  });

  final List<ChiTietPhieuNhap>? danhSachChiTietPhieuNhapDaThem;
  final void Function(ChiTietPhieuNhap)? onAddChiTietPhieuNhap;
  final ChiTietPhieuNhap? editChiTietNhapSach;

  @override
  State<AddEditEnterBookDetailForm> createState() =>
      _AddEditEnterBookDetailState();
}

class _AddEditEnterBookDetailState extends State<AddEditEnterBookDetailForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isOpen = false;

  /* Controller cho những TextField nằm trong Dialog Thêm chi tiết nhập sách */
  final _maSachController = TextEditingController();
  final _soLuongController = TextEditingController();
  final _donGiaController = TextEditingController();

  void _addChiTietNhapSach() {
    /* Thêm mới Chi Tiết Phiếu Nhập */
    ChiTietPhieuNhap newChiTietPhieuNhap = ChiTietPhieuNhap(
      null,
      int.parse(_maSachController.text),
      null,
      int.parse(_soLuongController.text),
      int.parse(_donGiaController.text.replaceAll('.', '')),
    );

    widget.onAddChiTietPhieuNhap!(newChiTietPhieuNhap);
  }

  void _editChiTietNhapSach() {
    /* Chỉnh sửa Chi Tiết Phiếu Nhập */
    widget.editChiTietNhapSach!.maSach = int.parse(_maSachController.text);
    widget.editChiTietNhapSach!.soLuong = int.parse(_soLuongController.text);
    widget.editChiTietNhapSach!.donGia =
        int.parse(_donGiaController.text.replaceAll('.', ''));
  }

  @override
  void initState() {
    super.initState();
    if (widget.editChiTietNhapSach != null) {
      _maSachController.text = widget.editChiTietNhapSach!.maSach.toString();
      _soLuongController.text = widget.editChiTietNhapSach!.soLuong.toString();
      _donGiaController.text = widget.editChiTietNhapSach!.donGia.toString();
    }
  }

  Future<bool> handleContain(int maSach) async {
    List<Sach> sachs = context.read<SachManagementCubit>().state.sachs!;
    await context.read<SachManagementCubit>().contains(maSach, sachs);
    if (mounted) {
      // ignore: use_build_context_synchronously
      return context.read<SachManagementCubit>().state.isContains;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    _maSachController.dispose();
    _soLuongController.dispose();
    _donGiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return AnimatedPadding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * (_isOpen ? 0.05 : 0.2) - (_isOpen ? 6 : 0)),
      duration: const Duration(milliseconds: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              /* Danh sách các Sách hiện có */
              AnimatedPadding(
                padding: EdgeInsets.only(
                    right: _isOpen ? 12 + screenWidth * 0.3 : 0),
                duration: const Duration(milliseconds: 200),
                child: TatCaSach(
                  openThemSachMoiForm: () => setState(() {
                    _isOpen = true;
                  }),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              /*
                    Thêm Sách mới
                    */
              Positioned(
                right: 0,
                child: IgnorePointer(
                  ignoring: !_isOpen,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _isOpen ? 1 : 0,
                    child: AnimatedSlide(
                      offset:
                          _isOpen ? const Offset(0, 0) : const Offset(-0.15, 0),
                      duration: const Duration(milliseconds: 200),
                      child: ThemSachMoiForm(
                        onClose: () => setState(() {
                          _isOpen = false;
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.editChiTietNhapSach == null
                                ? 'THÊM CHI TIẾT PHIẾU NHẬP'
                                : 'SỬA CHI TIẾT NHẬP SÁCH',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Mã Sách',
                              controller: _maSachController,
                              customValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bạn chưa nhập Mã Sách';
                                }

                                int? maSach = int.tryParse(value);
                                if (maSach == null) {
                                  return 'Mã Sách phải là con số';
                                }

                                if (handleContain(maSach) == false) {
                                  return 'Mã Sách không tồn tại';
                                }

                                if (widget.danhSachChiTietPhieuNhapDaThem!
                                        .indexWhere((element) =>
                                            element.maSach == maSach) !=
                                    -1) {
                                  return 'Mã Sách này đã được thêm vào Phiếu Nhập';
                                }

                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Số Lượng',
                              controller: _soLuongController,
                              customValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bạn chưa nhập Số Lượng';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Số Lượng phải là con số';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: LabelTextFormField(
                              labelText: 'Đơn Giá',
                              controller: _donGiaController,
                              suffixText: 'VND',
                              customValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bạn chưa nhập Đơn Giá';
                                }

                                if (int.tryParse(value.replaceAll('.', '')) ==
                                    null) {
                                  return 'Đơn Giá phải là con số';
                                }
                                return null;
                              },
                              onEditingComplete: () {
                                var text = _donGiaController.text;
                                try {
                                  _donGiaController.text = int.parse(text)
                                      .toVnCurrencyWithoutSymbolFormat();
                                } catch (e) {
                                  // Do nothing
                                  // print('Parse FAILED');
                                }
                                FocusScope.of(context).unfocus();
                              },
                              onTap: () {
                                _donGiaController.text =
                                    _donGiaController.text.replaceAll('.', '');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      widget.editChiTietNhapSach != null
                          ? Align(
                              alignment: Alignment.center,
                              child: FilledButton(
                                onPressed: () {
                                  bool isValid =
                                      _formKey.currentState!.validate();
                                  if (isValid) {
                                    _editChiTietNhapSach();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Chỉnh sửa Chi tiết Nhập sách thành công.'),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 3),
                                        width: 300,
                                      ),
                                    );
                                    Navigator.of(context).pop('updated');
                                  }
                                },
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 20,
                                  ),
                                ),
                                child: const Text(
                                  'Lưu',
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FilledButton(
                                  onPressed: () {
                                    bool isValid =
                                        _formKey.currentState!.validate();
                                    if (isValid) {
                                      _addChiTietNhapSach();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Thêm Chi tiết Nhập sách thành công.'),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 3),
                                          width: 300,
                                        ),
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text(
                                    'Thêm và Đóng',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    bool isValid =
                                        _formKey.currentState!.validate();
                                    if (isValid) {
                                      _addChiTietNhapSach();
                                      _maSachController.clear();
                                      _soLuongController.clear();
                                      _donGiaController.clear();
                                    }
                                  },
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text(
                                    'Thêm tiếp',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
