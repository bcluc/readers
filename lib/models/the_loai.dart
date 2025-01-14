import 'package:readers/models/prototype.dart';

class TheLoai implements Prototype<TheLoai> {
  int? maTheLoai;
  String tenTheLoai;

  TheLoai(
    this.maTheLoai,
    this.tenTheLoai,
  );

  @override
  TheLoai clone() {
    return TheLoai(maTheLoai, tenTheLoai);
  }

  static TheLoai creatNewTemplate() {
    return TheLoai(null, "");
  }

  TheLoai cloneWith({
    int? maTheLoai,
    String? tenTheLoai,
  }) {
    return TheLoai(maTheLoai ?? this.maTheLoai, tenTheLoai ?? this.tenTheLoai);
  }
}
