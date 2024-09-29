import 'package:readers/utils/extension.dart';

class CuonSachDto2th {
  String maCuonSach;
  int maSach;
  String tenDauSach;
  int lanTaiBan;
  String nhaXuatBan;
  String viTri;
  List<String> tacGias;

  CuonSachDto2th(
    this.maCuonSach,
    this.maSach,
    this.tenDauSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.viTri,
    this.tacGias,
  );

  String tacGiasToString() {
    if (tacGias.isEmpty) {
      return "Chưa có tác giả";
    }

    String str = "";
    for (var tacGia in tacGias) {
      str += '${tacGia.capitalizeFirstLetterOfEachWord()}, ';
    }
    return str.substring(0, str.length - 2);
  }
}
