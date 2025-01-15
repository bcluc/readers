import 'package:dart_date/dart_date.dart';
import 'package:readers/main.dart';
import 'package:readers/models/phieu_muon.dart';
import 'package:readers/utils/CoR/save_phieu_muon_base_handler.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/parameters.dart';

class SaveDataHandler extends LuuPhieuMuonBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    String maDocGia = context['maDocGia'];
    List cuonSachs = context['cuonSachs'];
    DateTime ngayMuon = vnDateFormat.parse(context['ngayMuon']);
    DateTime hanTra = ngayMuon.addDays(ThamSoQuyDinh.soNgayMuonToiDa);

    for (var cuonSach in cuonSachs) {
      final phieuMuon = PhieuMuon(
        null,
        cuonSach.maCuonSach,
        int.parse(maDocGia),
        ngayMuon,
        hanTra,
        'Đang mượn',
      );

      await dbProcess.insertPhieuMuon(phieuMuon);
      await dbProcess.updateTinhTrangCuonSachWithMaCuonSach(
          phieuMuon.maCuonSach, 'Đang mượn');
    }

    context['success'] = true;
  }
}
