import 'package:readers/utils/extension.dart';

class PhieuMuonCanTraDto {
  int? maPhieuMuon;
  String maCuonSach;
  String tenDauSach;
  int lanTaiBan;
  String nhaXuatBan;
  DateTime ngayMuon;
  DateTime hanTra;
  List<String> tacGias;

  PhieuMuonCanTraDto(
    this.maPhieuMuon,
    this.maCuonSach,
    this.tenDauSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.ngayMuon,
    this.hanTra,
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
