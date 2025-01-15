import 'package:readers/interface/sach_component.dart';
import 'package:readers/main.dart';

class CuonSach implements SachComponent {
  final String maCuonSach;
  String tinhTrang;
  String viTri;

  CuonSach(this.maCuonSach, this.tinhTrang, this.viTri);

  Future<void> updateTinhTrang(String newTinhTrang) async {
    tinhTrang = newTinhTrang;
    await dbProcess.updateViTriCuonSach(maCuonSach, newTinhTrang);
  }

  void updateViTri(String newViTri) {
    viTri = newViTri;
    print("Cập nhật vị trí: $newViTri cho cuốn sách $maCuonSach");
  }

  @override
  void create() {
    print("Tạo Cuốn Sách: $maCuonSach");
  }

  @override
  void update() {
    print("Cập nhật Cuốn Sách: $maCuonSach");
  }
}
