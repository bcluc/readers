import 'package:readers/interface/sach_component.dart';

base class Sach implements SachComponent {
  int? maSach;
  int lanTaiBan;
  String nhaXuatBan;
  int maDauSach;
  String tenDauSach;

  Sach(
    this.maSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.maDauSach,
    this.tenDauSach,
  );

  Map<String, dynamic> toMap() {
    return {
      'MaSach': maSach,
      'LanTaiBan': lanTaiBan,
      'NhaXuatBan': nhaXuatBan,
      'MaDauSach': maDauSach,
      'TenDauSach': tenDauSach,
    };
  }

  @override
  bool contain(int maSach) {
    return this.maSach == maSach;
  }
}
