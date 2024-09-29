import 'package:readers/utils/extension.dart';

class PhieuTra {
  int? maPhieuTra;
  int maPhieuMuon;
  DateTime ngayTra;
  int soTienPhat;

  PhieuTra(
    this.maPhieuTra,
    this.maPhieuMuon,
    this.ngayTra,
    this.soTienPhat,
  );

  Map<String, dynamic> toMap() {
    return {
      'MaPhieuTra': maPhieuTra,
      'MaPhieuMuon': maPhieuMuon,
      'NgayTra': ngayTra.toVnFormat(),
      'SoTienPhat': soTienPhat,
    };
  }
}
