import 'package:readers/utils/extension.dart';

class PhieuNhap {
  int? maPhieuNhap;
  DateTime ngayLap;
  int tongTien;

  PhieuNhap(
    this.maPhieuNhap,
    this.ngayLap,
    this.tongTien,
  );

  Map<String, dynamic> toMap() {
    return {
      'NgayLap': ngayLap.toVnFormat(),
    };
  }
}
