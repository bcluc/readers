import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/components/label_text_form_field_datepicker.dart';
import 'package:readers/cubit/selected_cuon_sach_cho_muon.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/screens/borrow_return/muon_sach/xuat_phieu_muon_switch.dart';
import 'package:readers/screens/borrow_return/muon_sach/sach_da_chon.dart';
import 'package:readers/screens/borrow_return/muon_sach/sach_trong_kho.dart';
import 'package:readers/utils/CoR/save_data_handler.dart';
import 'package:readers/utils/CoR/save_phieu_muon_base_handler.dart';
import 'package:readers/utils/CoR/validate_borrowing_books_return_date_handler.dart';
import 'package:readers/utils/CoR/validate_cuon_sach_handler.dart';
import 'package:readers/utils/CoR/validate_expire_date_handler.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_empty_handler.dart';
import 'package:readers/utils/CoR/validate_mdg_exist_handler.dart';
import 'package:readers/utils/CoR/validate_mdg_null_string_handler.dart';
import 'package:readers/utils/CoR/validate_num_of_books_borrowing_handler.dart';
import 'package:readers/utils/Export_file_strategy/export_file_excel_strategy.dart';
import 'package:readers/utils/Export_file_strategy/export_file_pdf_strategy.dart';
import 'package:readers/utils/Export_file_strategy/export_file_strategy.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/facade/excel_facade/excel_facade.dart';
import 'package:readers/utils/facade/pdf_facade/pdf_facade.dart';
import 'package:readers/utils/parameters.dart';

class MuonSach extends StatefulWidget {
  const MuonSach({super.key});

  @override
  State<MuonSach> createState() => _MuonSachState();
}

class _MuonSachState extends State<MuonSach> {
  final _searchMaDocGiaController = TextEditingController();
  final _ngayMuonController = TextEditingController(
    text: DateTime.now().toVnFormat(),
  );
  final _hanTraController = TextEditingController(
    text: DateTime.now().addDays(ThamSoQuyDinh.soNgayMuonToiDa).toVnFormat(),
  );

  /*
  Có thể cho _maCuonSachToAddCuonSachController vào trong SachDaChon() cũng được
  Nhưng khi MuonSach() rebuild 
  thì _maCuonSachToAddCuonSachController cũng sẽ được tạo lại trong SachDaChon()
  => Mất giá trị đang nhập
  */
  final _maCuonSachToAddCuonSachController = TextEditingController();
  final _searchCuonSachController = TextEditingController();
  late Exportfilestrategy _exportFileStrategy;

  bool _isProcessingMaDocGia = false;
  bool _isProcessingLuuPhieuMuon = false;

  String _errorText = '';
  String _maDocGia = '';
  String _hoTenDocGia = '';
  String _soSachDangMuon = '';
  bool _isInPhieuMuon = true;
  // ignore: unused_field
  bool _exportAsPDF = true;
  String _selectedOption = 'Pdf';

  Future<void> _searchMaDocGia() async {
    // _errorText = '';
    // if (_searchMaDocGiaController.text.isEmpty) {
    //   _errorText = 'Bạn chưa nhập Mã Độc giả.';
    // } else {
    //   if (int.tryParse(_searchMaDocGiaController.text) == null) {
    //     _errorText = 'Mã Độc giả là một con số.';
    //   }
    // }

    // if (_errorText.isNotEmpty) {
    //   setState(() {});
    //   return;
    // }

    // setState(() {
    //   _isProcessingMaDocGia = true;
    // });

    // _hoTenDocGia = '';
    // _soSachDangMuon = '';
    // _maDocGia = '';

    // int maDocGia = int.parse(_searchMaDocGiaController.text);

    // String? hoTen = await dbProcess.queryHoTenDocGiaWithMaDocGia(maDocGia);
    // await Future.delayed(const Duration(milliseconds: 200));

    // if (hoTen == null) {
    //   _errorText = 'Không tìm thấy Độc giả.';
    // } else {
    //   _hoTenDocGia = hoTen.capitalizeFirstLetterOfEachWord();

    //   /* Kiểm tra thẻ Độc giả còn hạn hay không */
    //   if (!await dbProcess.kiemTraHanTheDocGia(maDocGia)) {
    //     /* Hết hạn */
    //     // ignore: use_build_context_synchronously
    //     await showDialog(
    //       context: context,
    //       builder: (ctx) => Dialog(
    //         surfaceTintColor: Colors.transparent,
    //         child: SizedBox(
    //           width: 300,
    //           child: Padding(
    //             padding: const EdgeInsets.all(20),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.cancel_outlined,
    //                   color: Theme.of(context).colorScheme.primary,
    //                   size: 52,
    //                 ),
    //                 const Gap(12),
    //                 Text(
    //                   'Thẻ Độc giả $_hoTenDocGia \n đã hết hạn',
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.bold,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const Gap(16),
    //                 FilledButton(
    //                   onPressed: () => Navigator.of(context).pop(),
    //                   child: const Text('Đóng'),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );

    //     _searchMaDocGiaController.clear();
    //     _hoTenDocGia = '';

    //     setState(() {
    //       _isProcessingMaDocGia = false;
    //     });
    //     return;
    //   }
    //   _maDocGia = maDocGia.toString();

    //   _soSachDangMuon =
    //       (await dbProcess.querySoSachDangMuonCuaDocGia(maDocGia)).toString();

    //   int soSachQuaHan =
    //       await dbProcess.querySoSachMuonQuahanCuaDocGia(maDocGia);

    //   if (soSachQuaHan > 0 && mounted) {
    //     showDialog(
    //       context: context,
    //       builder: (ctx) => Dialog(
    //         surfaceTintColor: Colors.transparent,
    //         child: SizedBox(
    //           width: 300,
    //           child: Padding(
    //             padding: const EdgeInsets.all(20),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                   Icons.warning_rounded,
    //                   color: Theme.of(context).colorScheme.primary,
    //                   size: 52,
    //                 ),
    //                 const Gap(10),
    //                 const Text(
    //                   'Lưu ý',
    //                   style: TextStyle(
    //                     fontSize: 16,
    //                   ),
    //                 ),
    //                 const Gap(4),
    //                 Text(
    //                   'Độc giả $_hoTenDocGia có \n $soSachQuaHan cuốn sách quá hạn',
    //                   style: const TextStyle(
    //                     fontSize: 16,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //                 const Gap(16),
    //                 FilledButton(
    //                   onPressed: () => Navigator.of(context).pop(),
    //                   child: const Text('Đóng'),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   }
    // }

    // setState(() {
    //   _isProcessingMaDocGia = false;
    // });
    Map<String, dynamic> context = {'maDocGia': _searchMaDocGiaController.text};

    // Search Chain
    ValidateMaDocGiaBaseHandler expireValidate = ValidateMDGExpireDateHandler();
    ValidateMaDocGiaBaseHandler numOfBooksValidate =
        ValidateNumOfBooksBorrowingHandler();
    ValidateMaDocGiaBaseHandler overdueBooksValidate =
        ValidateBorrowingBooksReturnDateHandler();

    expireValidate.setNext(numOfBooksValidate);
    numOfBooksValidate.setNext(overdueBooksValidate);
    await expireValidate.handle(context);

    if (context.containsKey('error')) {
      setState(() {
        _errorText = context['error'];
      });
      return;
    }

    setState(() {
      _maDocGia = context['maDocGia'];
      _hoTenDocGia = context['hoTenDocGia'];
    });
  }

  void _savePhieuMuons(List<CuonSachDto2th> cuonSachs) async {
    /* Kiểm tra mã độc giả đã được nhập đúng đắn chưa */
    // if (_maDocGia.isEmpty) {
    //   await _searchMaDocGia();
    //   if (_maDocGia.isEmpty) {
    //     return;
    //   }
    // }

    // _errorText = '';
    // if (cuonSachs.isEmpty) {
    //   setState(() {
    //     _errorText = 'Bạn chưa thêm cuốn sách nào';
    //   });
    //   return;
    // }

    // setState(() {
    //   _isProcessingLuuPhieuMuon = true;
    // });

    // int maDocGia = int.parse(_maDocGia);

    // for (var cuonSach in cuonSachs) {
    //   DateTime ngayMuon = vnDateFormat.parse(_ngayMuonController.text);

    //   final phieuMuon = PhieuMuon(
    //     null,
    //     cuonSach.maCuonSach,
    //     maDocGia,
    //     ngayMuon,
    //     ngayMuon.addDays(ThamSoQuyDinh.soNgayMuonToiDa),
    //     'Đang mượn',
    //   );

    //   /* Không cần await cũng được */
    //   await dbProcess.insertPhieuMuon(phieuMuon);
    //   await dbProcess.updateTinhTrangCuonSachWithMaCuonSach(
    //       phieuMuon.maCuonSach, 'Đang mượn');
    // }
    // await Future.delayed(const Duration(milliseconds: 200));

    // if (mounted) {
    //   context.read<SelectedCuonSachChoMuonCubit>().clear();

    //   /* Hiện thị thông báo lưu Phiếu mượn thành công */
    //   ScaffoldMessenger.of(context).clearSnackBars();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Lưu Phiếu mượn thành công',
    //         textAlign: TextAlign.center,
    //       ),
    //       behavior: SnackBarBehavior.floating,
    //       duration: Duration(seconds: 3),
    //       width: 300,
    //     ),
    //   );
    // }

    // if (_isInPhieuMuon) {
    //   PdfFacade.generateAndOpenPhieuMuon(_ngayMuonController.text,
    //       _hanTraController.text, _maDocGia, _hoTenDocGia, cuonSachs);
    // }

    // /* Sau khi lưu xong dữ liệu vào DB thì ta reset lại trang */
    // _searchMaDocGiaController.clear();

    // _searchCuonSachController.clear();
    // _maCuonSachToAddCuonSachController.clear();
    // setState(() {
    //   _maDocGia = '';
    //   _hoTenDocGia = '';
    //   _soSachDangMuon = '';
    // });

    // setState(() {
    //   _isProcessingLuuPhieuMuon = false;
    // });

    Map<String, dynamic> saveDataContext = {
      'maDocGia': _maDocGia,
      'cuonSachs': cuonSachs,
      'ngayMuon': _ngayMuonController.text
    };

    // Save Chain
    LuuPhieuMuonBaseHandler saveChain = ValidateMDGEmptyHandler();
    LuuPhieuMuonBaseHandler validateCuonSach = ValidateCuonSachHandler();
    LuuPhieuMuonBaseHandler saveData = SaveDataHandler();
    saveChain.setNext(validateCuonSach);
    validateCuonSach.setNext(saveData);

    await saveChain.handle(saveDataContext);

    if (saveDataContext.containsKey('error')) {
      setState(() {
        _errorText = saveDataContext['error'];
      });
      return;
    }

    setState(() {
      _errorText = '';
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lưu Phiếu Mượn thành công')),
      );
    });

    if (_isInPhieuMuon) {
      if (_selectedOption == 'Pdf') {
        _exportFileStrategy = ExportFilePdfStrategy();
        _exportFileStrategy.XuatPhieuMuon(_ngayMuonController.text,
            _hanTraController.text, _maDocGia, _hoTenDocGia, cuonSachs);
      } else {
        _exportFileStrategy = ExportFileExcelStrategy(ExcelFacade());
        _exportFileStrategy.XuatPhieuMuon(_ngayMuonController.text,
            _hanTraController.text, _maDocGia, _hoTenDocGia, cuonSachs);
      }
    }

    /* Sau khi lưu xong dữ liệu vào DB thì ta reset lại trang */
    _searchMaDocGiaController.clear();

    _searchCuonSachController.clear();
    _maCuonSachToAddCuonSachController.clear();
    setState(() {
      _maDocGia = '';
      _hoTenDocGia = '';
      _soSachDangMuon = '';
    });

    setState(() {
      _isProcessingLuuPhieuMuon = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _ngayMuonController.addListener(() {
      _hanTraController.text = vnDateFormat
          .parse(_ngayMuonController.text)
          .addDays(ThamSoQuyDinh.soNgayMuonToiDa)
          .toVnFormat();
    });
  }

  @override
  void dispose() {
    _searchMaDocGiaController.dispose();
    _ngayMuonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tìm Độc giả',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchMaDocGiaController,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 245, 246, 250),
                              hintText: 'Nhập Mã độc giả',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              isCollapsed: true,
                              errorMaxLines: 2,
                            ),
                            onEditingComplete: _searchMaDocGia,
                          ),
                        ),
                        const Gap(10),
                        _isProcessingMaDocGia
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                height: 44,
                                width: 44,
                                padding: const EdgeInsets.all(12),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton.filled(
                                onPressed: _searchMaDocGia,
                                icon: const Icon(Icons.arrow_downward_rounded),
                                style: myIconButtonStyle,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                child: LabelTextFieldDatePicker(
                  labelText: 'Ngày mượn',
                  controller: _ngayMuonController,
                ),
              ),
              const Gap(30),
              Expanded(
                child: LabelTextFormField(
                  labelText: 'Hạn trả',
                  controller: _hanTraController,
                  isEnable: false,
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(),
          const Gap(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Mã Độc giả: $_maDocGia',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Họ tên: $_hoTenDocGia',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Số sách đang mượn: $_soSachDangMuon',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Số sách được mượn tối đa: ${ThamSoQuyDinh.soSachMuonToiDa}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
              Expanded(
                child: Column(
                  children: [
                    XuatPhieuMuonSwitch(
                      onSwitchChanged: (value) => _isInPhieuMuon = value,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'Pdf',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                            title: const Text('Pdf'),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'Excel',
                            groupValue: _selectedOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedOption = value!;
                              });
                            },
                            title: const Text('Excel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(),
          const Gap(10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /* SÁCH TRONG KHO */
                      Expanded(
                        child: SachTrongKho(
                          _searchCuonSachController,
                          soSachCoTheMuon: ThamSoQuyDinh.soSachMuonToiDa -
                              (_soSachDangMuon.isEmpty
                                  ? -1
                                  : int.parse(_soSachDangMuon)),
                        ),
                      ),
                      /* Khoảng trắng 30 pixel */
                      const Gap(30),
                      /* SÁCH ĐÃ CHỌN */
                      Expanded(
                        child: SachDaChon(
                          _maCuonSachToAddCuonSachController,
                          soSachCoTheMuon: ThamSoQuyDinh.soSachMuonToiDa -
                              (_soSachDangMuon.isEmpty
                                  ? -1
                                  : int.parse(_soSachDangMuon)),
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(18),
                Row(
                  children: [
                    Text(
                      _errorText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _isProcessingLuuPhieuMuon
                        ? const SizedBox(
                            height: 44,
                            width: 123,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 49.5),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : FilledButton(
                            onPressed: () => _savePhieuMuons(
                              context
                                  .read<SelectedCuonSachChoMuonCubit>()
                                  .state,
                            ),
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
                              'Lưu phiếu',
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
