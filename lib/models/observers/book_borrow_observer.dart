import 'package:flutter/material.dart';

// Abstract Observer
abstract class BookBorrowObserver {
  void onBookBorrowed(String maCuonSach, String tenSach);
  void onBookReturned(String maCuonSach, String tenSach);
  void onBookStatusChanged(String maCuonSach, String tinhTrang);
}

// Subject that maintains list of observers
class BookBorrowSubject {
  static final BookBorrowSubject _instance = BookBorrowSubject._internal();
  factory BookBorrowSubject() => _instance;
  BookBorrowSubject._internal();

  final List<BookBorrowObserver> _observers = [];

  void addObserver(BookBorrowObserver observer) {
    if (!_observers.contains(observer)) {
      _observers.add(observer);
    }
  }

  void removeObserver(BookBorrowObserver observer) {
    _observers.remove(observer);
  }

  void notifyBookBorrowed(String maCuonSach, String tenSach) {
    for (var observer in _observers) {
      observer.onBookBorrowed(maCuonSach, tenSach);
    }
  }

  void notifyBookReturned(String maCuonSach, String tenSach) {
    for (var observer in _observers) {
      observer.onBookReturned(maCuonSach, tenSach);
    }
  }

  void notifyBookStatusChanged(String maCuonSach, String tinhTrang) {
    for (var observer in _observers) {
      observer.onBookStatusChanged(maCuonSach, tinhTrang);
    }
  }
}
