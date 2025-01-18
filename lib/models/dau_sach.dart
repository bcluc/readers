import 'package:readers/interface/sach_component.dart';

class DauSach implements SachComponent {
  int? maDauSach;
  String tenDauSach;

  final List<SachComponent> _sachs = [];

  DauSach(
    this.maDauSach,
    this.tenDauSach,
  );

  @override
  bool contain(int maSach) {
    for (var sach in _sachs) {
      if (sach.contain(maSach)) {
        return true;
      }
    }
    return false;
  }

  void addSach(SachComponent sach) => _sachs.add(sach);
  void removeSach(SachComponent sach) => _sachs.remove(sach);
  List<SachComponent> get sachs => List.unmodifiable(_sachs);
}
