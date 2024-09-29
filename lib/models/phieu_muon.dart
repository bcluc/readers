import 'package:readers/utils/extension.dart';

class PhieuMuon {
  int? maPhieuMuon;
  String maCuonSach;
  int maDocGia;
  DateTime ngayMuon;
  DateTime hanTra;
  String tinhTrang;

  PhieuMuon(
    this.maPhieuMuon,
    this.maCuonSach,
    this.maDocGia,
    this.ngayMuon,
    this.hanTra,
    this.tinhTrang,
  );

  Map<String, dynamic> toMap() {
    return {
      'MaCuonSach': maCuonSach,
      'MaDocGia': maDocGia,
      'NgayMuon': ngayMuon.toVnFormat(),
      'HanTra': hanTra.toVnFormat(),
      'TinhTrang': tinhTrang,
    };
  }
}
