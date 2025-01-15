import 'package:readers/interface/sach_component.dart';

import 'observers/book_status_observer.dart';

class CuonSach implements SachComponent {
  int? maCuonSach;
  String tinhTrang;
  String viTri;
  static final BookStatusSubject _statusSubject = BookStatusSubject();

  CuonSach(
    this.maCuonSach,
    this.tinhTrang,
    this.viTri,
  );

  static void addObserver(BookStatusObserver observer) {
    _statusSubject.addObserver(observer);
  }

  static void removeObserver(BookStatusObserver observer) {
    _statusSubject.removeObserver(observer);
  }

  void updateStatus(String newTinhTrang, String newViTri) {
    if (newTinhTrang != tinhTrang) {
      final oldTinhTrang = tinhTrang;
      tinhTrang = newTinhTrang;
      _statusSubject.notifyStatusChanged(
        maCuonSach.toString(),
        oldTinhTrang,
        newTinhTrang,
      );
    }

    if (newViTri != viTri) {
      final oldViTri = viTri;
      viTri = newViTri;
      _statusSubject.notifyLocationChanged(
        maCuonSach.toString(),
        oldViTri,
        newViTri,
      );
    }
  }

  @override
  void create() {
    // TODO: implement create
  }

  @override
  void update() {
    // TODO: implement update
  }
}
