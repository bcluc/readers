import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/label_text_form_field_datepicker.dart';
import 'package:readers/dto/chi_tiet_phieu_nhap_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/models/phieu_nhap.dart';
import 'package:readers/screens/book_manage/quan_ly_phieu_nhap/edit_don_gia_form.dart';
import 'package:readers/screens/book_manage/quan_ly_phieu_nhap/edit_so_luong_form.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

class QuanLyPhieuNhap extends StatefulWidget {
  const QuanLyPhieuNhap({super.key});

  @override
  State<QuanLyPhieuNhap> createState() => _QuanLyPhieuNhapState();
}

class _QuanLyPhieuNhapState extends State<QuanLyPhieuNhap> {
  late final List<PhieuNhap> _phieuNhaps;
  late List<PhieuNhap> _filteredPhieuNhaps;
  int selectedRow = -1;

  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  List<ChiTietPhieuNhapDto> _chiTietPhieuNhap = [];

  late final Future<void> _futurePhieuNhaps = getPhieuNhaps();
  Future<void> getPhieuNhaps() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    /* Lấy dữ liệu Phiếu Nhập từ database */
    _phieuNhaps = await dbProcess.queryPhieuNhap();

    if (_phieuNhaps.isNotEmpty) {
      /* 
      Sắp xếp các Phiếu nhập theo thứ tặng Ngày Lập giảm dần 
      => Phiếu Nhập mới nhất sẽ lên đầu bảng 
      */
      _phieuNhaps.sort((a, b) => b.ngayLap.compareTo(a.ngayLap));
      // for (var phieuNhap in phieuNhaps) {
      //   print("('${phieuNhap.maPhieuNhap}', '${phieuNhap.ngayLap.toVnFormat()}', '${phieuNhap.tongTien}')");
      // }
      _startDateController.text = _phieuNhaps.last.ngayLap.toVnFormat();
      _endDateController.text = _phieuNhaps.first.ngayLap.toVnFormat();
    }
  }

  @override
  void initState() {
    super.initState();

    _startDateController.addListener(
      () => setState(() {
        _startDate = vnDateFormat.parse(_startDateController.text);
      }),
    );
    _endDateController.addListener(
      () => setState(() {
        _endDate = vnDateFormat.parse(_endDateController.text);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futurePhieuNhaps,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_phieuNhaps.isNotEmpty) {
          _filteredPhieuNhaps = _phieuNhaps
              .where(
                (element) =>
                    (_startDate.isBefore(element.ngayLap) ||
                        _startDate.isAtSameMomentAs(element.ngayLap)) &&
                    (element.ngayLap.isBefore(_endDate) ||
                        element.ngayLap.isAtSameMomentAs(_endDate)),
              )
              .toList();
        } else {
          _filteredPhieuNhaps = [];
        }
        // print('filteredPhieuNhaps.length = ${filteredPhieuNhaps.length}');

        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* Bộ Lọc */
              Row(
                children: [
                  Expanded(
                    child: LabelTextFieldDatePicker(
                      labelText: 'Từ ngày',
                      controller: _startDateController,
                      initialDateInPicker: _startDate,
                      lastDate: _endDate,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: LabelTextFieldDatePicker(
                      labelText: 'Đến ngày',
                      controller: _endDateController,
                      firstDate: _startDate,
                      initialDateInPicker: _endDate,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _phieuNhaps.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text(
                          'Chưa có dữ liệu Phiếu nhập',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 583,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Danh sách Phiếu Nhập',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 30,
                                          ),
                                          child: const Row(
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  'Mã Phiếu',
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
                                                    'Ngày lập',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 15),
                                                  child: Text(
                                                    'Tổng tiền',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                                _filteredPhieuNhaps.length,
                                                (index) {
                                              bool isNgayLapHover = false;
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
                                                      onTap: () async {
                                                        selectedRow = index;
                                                        _chiTietPhieuNhap = await dbProcess
                                                            .queryChiTietPhieuNhapDtoWithMaPhieuNhap(
                                                                _filteredPhieuNhaps[
                                                                        selectedRow]
                                                                    .maPhieuNhap!);
                                                        setState(() {});
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Gap(30),
                                                          SizedBox(
                                                            width: 80,
                                                            child: Text(
                                                              _filteredPhieuNhaps[
                                                                      index]
                                                                  .maPhieuNhap
                                                                  .toString(),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                StatefulBuilder(
                                                              builder: (ctx,
                                                                  setStateInkWell) {
                                                                return InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    DateTime?
                                                                        newNgayLap =
                                                                        await showDatePicker(
                                                                      context:
                                                                          context,
                                                                      initialDate:
                                                                          _filteredPhieuNhaps[index]
                                                                              .ngayLap,
                                                                      firstDate:
                                                                          DateTime(
                                                                              1950),
                                                                      lastDate:
                                                                          DateTime
                                                                              .now(),
                                                                    );
                                                                    if (newNgayLap !=
                                                                        null) {
                                                                      setStateInkWell(
                                                                        () => _filteredPhieuNhaps[index].ngayLap =
                                                                            newNgayLap,
                                                                      );
                                                                      dbProcess.updateNgayLapPhieuNhap(
                                                                          _filteredPhieuNhaps[
                                                                              index]);
                                                                    }
                                                                  },
                                                                  onHover: (value) =>
                                                                      setStateInkWell(() =>
                                                                          isNgayLapHover =
                                                                              value),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          13,
                                                                      horizontal:
                                                                          15,
                                                                    ),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          24,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            _filteredPhieuNhaps[index].ngayLap.toVnFormat(),
                                                                          ),
                                                                          const Spacer(),
                                                                          if (isNgayLapHover)
                                                                            const Icon(Icons.edit_calendar_rounded),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 15,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      _filteredPhieuNhaps[
                                                                              index]
                                                                          .tongTien
                                                                          .toVnCurrencyWithoutSymbolFormat(),
                                                                    ),
                                                                  ),
                                                                  const Gap(10),
                                                                  if (selectedRow ==
                                                                      index)
                                                                    Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Theme.of(
                                                                              context)
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
                                                  if (index <
                                                      _filteredPhieuNhaps
                                                              .length -
                                                          1)
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
                            ),
                          ),
                          const Gap(50),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Chi tiết Phiếu Nhập',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          child: const Row(
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 30, right: 15),
                                                  child: Text(
                                                    'Mã CTPN',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 7,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    'Tên Đầu sách',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    'Số lượng',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 15, right: 30),
                                                  child: Text(
                                                    'Đơn giá',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontStyle:
                                                          FontStyle.italic,
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
                                                _chiTietPhieuNhap.length,
                                                (index) {
                                              bool isSoLuongHover = false;
                                              bool isDonGiaHover = false;
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 120,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 30,
                                                                  right: 15),
                                                          child: Text(
                                                            _chiTietPhieuNhap[
                                                                    index]
                                                                .maCTPN
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 7,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 15,
                                                          ),
                                                          child: Text(
                                                            _chiTietPhieuNhap[
                                                                    index]
                                                                .tenDauSach
                                                                .capitalizeFirstLetterOfEachWord(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: StatefulBuilder(
                                                            builder: (ctx,
                                                                setStateSoLuongInkWell) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              int? newSoLuong =
                                                                  await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) =>
                                                                    EditSoLuongForm(
                                                                  soLuong: _chiTietPhieuNhap[
                                                                          index]
                                                                      .soLuong,
                                                                ),
                                                              );
                                                              if (newSoLuong !=
                                                                  null) {
                                                                /* 
                                                                Sử dụng setState để refresh toàn bộ page,
                                                                Mới có thể cập nhật lại "Tổng Tiền" trong bảng "Danh sách Phiếu Nhập"
                                                                */
                                                                setState(() {
                                                                  _chiTietPhieuNhap[
                                                                              index]
                                                                          .soLuong =
                                                                      newSoLuong;
                                                                  _filteredPhieuNhaps[
                                                                              selectedRow]
                                                                          .tongTien =
                                                                      tinhTongTienChiTietPhieuNhaps();
                                                                });
                                                                dbProcess.updateSoLuongChiTietPhieuNhap(
                                                                    _chiTietPhieuNhap[
                                                                        index]);
                                                              }
                                                            },
                                                            onHover: (value) =>
                                                                setStateSoLuongInkWell(() =>
                                                                    isSoLuongHover =
                                                                        value),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 13,
                                                                horizontal: 15,
                                                              ),
                                                              child: SizedBox(
                                                                height: 24,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      _chiTietPhieuNhap[
                                                                              index]
                                                                          .soLuong
                                                                          .toString(),
                                                                    ),
                                                                    const Spacer(),
                                                                    if (isSoLuongHover)
                                                                      const Icon(
                                                                        Icons
                                                                            .edit_rounded,
                                                                      )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: StatefulBuilder(
                                                            builder: (ctx,
                                                                setStateDonGiaInkWell) {
                                                          return InkWell(
                                                            onTap: () async {
                                                              int? newDonGia =
                                                                  await showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) =>
                                                                    EditDonGiaForm(
                                                                  donGia: _chiTietPhieuNhap[
                                                                          index]
                                                                      .donGia,
                                                                ),
                                                              );
                                                              if (newDonGia !=
                                                                  null) {
                                                                /* 
                                                                Sử dụng setState để refresh toàn bộ page,
                                                                Mới có thể cập nhật lại "Tổng Tiền" trong bảng "Danh sách Phiếu Nhập"
                                                                */
                                                                setState(() {
                                                                  _chiTietPhieuNhap[
                                                                              index]
                                                                          .donGia =
                                                                      newDonGia;
                                                                  _filteredPhieuNhaps[
                                                                              selectedRow]
                                                                          .tongTien =
                                                                      tinhTongTienChiTietPhieuNhaps();
                                                                });
                                                                dbProcess.updateDonGiaChiTietPhieuNhap(
                                                                    _chiTietPhieuNhap[
                                                                        index]);
                                                              }
                                                            },
                                                            onHover: (value) =>
                                                                setStateDonGiaInkWell(() =>
                                                                    isDonGiaHover =
                                                                        value),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .fromLTRB(
                                                                      15,
                                                                      13,
                                                                      30,
                                                                      13),
                                                              child: SizedBox(
                                                                height: 24,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      _chiTietPhieuNhap[
                                                                              index]
                                                                          .donGia
                                                                          .toVnCurrencyWithoutSymbolFormat(),
                                                                    ),
                                                                    const Spacer(),
                                                                    if (isDonGiaHover)
                                                                      const Icon(
                                                                        Icons
                                                                            .edit_rounded,
                                                                      )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ],
                                                  ),
                                                  if (index <
                                                      _filteredPhieuNhaps
                                                              .length -
                                                          1)
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
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  int tinhTongTienChiTietPhieuNhaps() {
    return _chiTietPhieuNhap.fold(
      0,
      (previousValue, element) =>
          previousValue += element.soLuong * element.donGia,
    );
  }
}
