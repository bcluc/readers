import 'package:flutter/material.dart';
import 'book_borrow_observer.dart';

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

// Database Observer - Handles database updates
class DatabaseBookObserver implements BookBorrowObserver {
  @override
  void onBookBorrowed(String maCuonSach, String tenSach) {
    // Update database status
    // You can add your database update logic here
  }

  @override
  void onBookReturned(String maCuonSach, String tenSach) {
    // Update database status
    // You can add your database update logic here
  }

  @override
  void onBookStatusChanged(String maCuonSach, String tinhTrang) {
    // Update status in database
    // You can add your database update logic here
  }
}

// Statistics Observer - Handles borrowing statistics
class StatisticsBookObserver implements BookBorrowObserver {
  @override
  void onBookBorrowed(String maCuonSach, String tenSach) {
    // Update borrowing statistics
    // You can add your statistics tracking logic here
  }

  @override
  void onBookReturned(String maCuonSach, String tenSach) {
    // Update return statistics
    // You can add your statistics tracking logic here
  }

  @override
  void onBookStatusChanged(String maCuonSach, String tinhTrang) {
    // Update status statistics
    // You can add your statistics tracking logic here
  }
}
