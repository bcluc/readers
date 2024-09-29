import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/inform_dialog.dart';
import 'package:readers/main.dart';
import 'package:readers/models/phieu_tra.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';

class PhieuTraSection extends StatefulWidget {
  const PhieuTraSection({
    super.key,
    required this.maPhieuMuon,
    required this.maCuonSach,
    required this.hanTra,
    required this.onTraPhieu,
  });

  final int? maPhieuMuon;
  final String? maCuonSach;
  final DateTime? hanTra;
  final void Function() onTraPhieu;

  @override
  State<PhieuTraSection> createState() => _PhieuTraSectionState();
}

class _PhieuTraSectionState extends State<PhieuTraSection> {
  final _ngayTraController = TextEditingController(
    text: DateTime.now().toVnFormat(),
  );

  Future<void> openDatePicker(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (chosenDate != null) {
      setState(() {
        _ngayTraController.text = chosenDate.toVnFormat();
      });
      /* 
      Bản chất, 
      giá trị của TextField chứa _ngayTraController vẫn sẽ thay đổi và không cần gọi setState 
      nhưng, PHẢI gọi setState để cập nhật lại số tiền được hiển thị phụ thuộc vào ngày trả.
      */
    }
  }

  void _savePhieuTra(int soTienPhat) async {
    if (widget.maPhieuMuon == null) {
      showDialog(
        context: context,
        builder: (ctx) =>
            const InformDialog(content: 'Bạn chưa chọn Mã Phiếu mượn'),
      );

      return;
    }

    final phieuTra = PhieuTra(
      null,
      widget.maPhieuMuon!,
      vnDateFormat.parse(_ngayTraController.text),
      soTienPhat,
    );

    /* Thêm phiếu trả */
    dbProcess.insertPhieuTra(phieuTra);

    /* Cập nhật Trạng thái của Phiếu mượn = 'Đã trả' */
    dbProcess.updateTinhTrangPhieuMuonWithMaPhieuMuon(
        widget.maPhieuMuon!, 'Đã trả');

    /* Cập nhật Trạng thái Cuốn sách = 'Có Sẵn' */
    dbProcess.updateTinhTrangCuonSachWithMaCuonSach(
        widget.maCuonSach!, 'Có sẵn');

    /* Gọi phương thức từ Widget cha là TraSach để xử lý xóa phiếu mượn và trả */
    widget.onTraPhieu();

    /* Hiện thị thông báo lưu Phiếu mượn thành công */
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Lưu Phiếu trả thành công',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 300,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ngayTraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ngayTra = vnDateFormat.parse(_ngayTraController.text);

    int soTienPhat = 0;
    if (widget.hanTra != null && ngayTra > widget.hanTra!) {
      soTienPhat = ngayTra.differenceInDays(widget.hanTra!) *
          ThamSoQuyDinh.mucThuTienPhat;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'PHIẾU TRẢ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(6),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(22),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mã Phiếu mượn',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 44,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.maPhieuMuon == null
                                  ? ''
                                  : '${widget.maPhieuMuon}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
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
                          const Text(
                            'Ngày trả',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => openDatePicker(context),
                            child: TextField(
                              controller: _ngayTraController,
                              enabled: false,
                              mouseCursor: SystemMouseCursors.click,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'dd/MM/yyyy',
                                hintStyle:
                                    const TextStyle(color: Color(0xFF888888)),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                isCollapsed: true,
                                suffixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
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
                          const Text(
                            'Số tiền phạt',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 44,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              soTienPhat.toVnCurrencyFormat(),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                FilledButton(
                  onPressed: () => _savePhieuTra(soTienPhat),
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
                    'Lưu Phiếu trả',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
