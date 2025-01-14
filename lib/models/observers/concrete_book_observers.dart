import 'package:flutter/material.dart';
import 'package:readers/models/observers/book_borrow_observer.dart';

// UI Observer - Handles UI updates
class UIBookObserver implements BookBorrowObserver {
  final BuildContext context;

  UIBookObserver(this.context);

  @override
  void onBookBorrowed(String maCuonSach, String tenSach) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sách "$tenSach" (Mã: $maCuonSach) đã được mượn'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void onBookReturned(String maCuonSach, String tenSach) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sách "$tenSach" (Mã: $maCuonSach) đã được trả'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void onBookStatusChanged(String maCuonSach, String tinhTrang) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Trạng thái sách $maCuonSach đã thay đổi: $tinhTrang'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
