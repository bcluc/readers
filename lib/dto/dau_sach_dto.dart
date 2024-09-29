import 'package:readers/models/tac_gia.dart';
import 'package:readers/models/the_loai.dart';
import 'package:readers/utils/extension.dart';

class DauSachDto {
  int? maDauSach;
  String tenDauSach;
  int soLuong;
  List<TacGia> tacGias;
  List<TheLoai> theLoais;

  DauSachDto(
    this.maDauSach,
    this.tenDauSach,
    this.soLuong,
    this.tacGias,
    this.theLoais,
  );

  String tacGiasToString() {
    if (tacGias.isEmpty) {
      return "Chưa có tác giả";
    }

    String str = "";
    for (var tacGia in tacGias) {
      str += '${tacGia.tenTacGia.capitalizeFirstLetterOfEachWord()}, ';
    }
    return str.substring(0, str.length - 2);
  }

  String theLoaisToString() {
    if (theLoais.isEmpty) {
      return "Chưa có thể loại";
    }

    String str = "";
    for (var theLoai in theLoais) {
      str += '${theLoai.tenTheLoai.capitalizeFirstLetter()}, ';
    }
    return str.substring(0, str.length - 2);
  }
}
