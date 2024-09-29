import 'package:readers/utils/extension.dart';

class DocGia {
  DocGia(
    this.maDocGia,
    this.hoTen,
    this.ngaySinh,
    this.diaChi,
    this.soDienThoai,
    this.ngayLapThe,
    this.ngayHetHan,
  );

  int? maDocGia;
  String hoTen;
  DateTime ngaySinh;
  String diaChi;
  String soDienThoai;
  DateTime ngayLapThe;
  DateTime ngayHetHan;

  Map<String, dynamic> toMap() {
    return {
      'HoTen': hoTen,
      'NgaySinh': ngaySinh.toVnFormat(),
      'DiaChi': diaChi,
      'SoDienThoai': soDienThoai,
      'NgayLapThe': ngayLapThe.toVnFormat(),
      'NgayHetHan': ngayHetHan.toVnFormat(),
    };
  }
}
