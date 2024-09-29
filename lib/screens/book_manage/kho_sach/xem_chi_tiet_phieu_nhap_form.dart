import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/extension.dart';

class XemChiTietPhieuNhap extends StatelessWidget {
  XemChiTietPhieuNhap({
    super.key,
    required this.maCTPN,
  });

  final int maCTPN;
  final Map<String, dynamic> thongTinChiTiet = {};

  Future<void> _getThongTinChiTietPhieuNhapCuonSach() async {
    thongTinChiTiet
        .addAll(await dbProcess.queryThongTinChiTietPhieuNhapCuonSach(maCTPN));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: FutureBuilder(
              future: _getThongTinChiTietPhieuNhapCuonSach(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'CHI TIẾT PHIẾU NHẬP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        )
                      ],
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        const Text(
                          'Mã phiếu nhập ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '#${thongTinChiTiet['MaPhieuNhap']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${thongTinChiTiet['NgayLap']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        const Text(
                          'Số lượng: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${thongTinChiTiet['SoLuong']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Đơn giá: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          (thongTinChiTiet['DonGia'] as int)
                              .toVnCurrencyFormat(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
