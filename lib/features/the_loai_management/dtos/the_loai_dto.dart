import 'package:readers/models/prototype.dart';

class TheLoaiDto implements Prototype<TheLoaiDto> {
  int? maTheLoai;
  String tenTheLoai;
  int soLuongSach;

  TheLoaiDto(
    this.maTheLoai,
    this.tenTheLoai,
    this.soLuongSach,
  );
  @override
  TheLoaiDto clone() {
    return TheLoaiDto(maTheLoai, tenTheLoai, soLuongSach);
  }

  static TheLoaiDto creatNewTemplate() {
    return TheLoaiDto(null, "", 0);
  }

  TheLoaiDto cloneWith({
    int? maTheLoai,
    String? tenTheLoai,
    int? soLuongSach,
  }) {
    return TheLoaiDto(maTheLoai ?? this.maTheLoai,
        tenTheLoai ?? this.tenTheLoai, soLuongSach ?? this.soLuongSach);
  }
}
