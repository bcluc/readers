import 'package:readers/interface/sach_component.dart';
import 'package:readers/models/cuon_sach.dart';

class Sach implements SachComponent {
  int? maSach;
  int lanTaiBan;
  String nhaXuatBan;
  int maDauSach;
  String tenDauSach;
  final List<SachComponent> children = [];

  Sach(
    this.maSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.maDauSach,
    this.tenDauSach,
  );

  Map<String, dynamic> toMap() {
    return {
      'LanTaiBan': lanTaiBan,
      'NhaXuatBan': nhaXuatBan,
      'MaDauSach': maDauSach,
    };
  }

  void add(CuonSach cuonSach) {
    children.add(cuonSach);
    print("Thêm cuốn sách: ${cuonSach.maCuonSach}");
  }

  void remove(CuonSach cuonSach) {
    children.remove(cuonSach);
    print("Xóa cuốn sách: ${cuonSach.maCuonSach}");
  }

  bool isEmpty() => children.isEmpty;

  List<SachComponent> getList() => children;

  @override
  void create() {
    print("Tạo Sách: $tenDauSach");
  }

  @override
  void update() {
    print("Cập nhật Sách: $tenDauSach");
  }
}
