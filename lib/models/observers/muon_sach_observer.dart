import 'package:flutter/material.dart';
import 'book_status_observer.dart';

class MuonSachObserver implements BookStatusObserver {
  final BuildContext context;
  final Function(String) onMessage;

  MuonSachObserver(this.context, this.onMessage);

  @override
  void onStatusChanged(String maCuonSach, String oldStatus, String newStatus) {
    onMessage('Sách $maCuonSach đã thay đổi từ $oldStatus sang $newStatus');
  }

  @override
  void onLocationChanged(String maCuonSach, String oldLocation, String newLocation) {
    onMessage('Vị trí sách $maCuonSach đã thay đổi từ $oldLocation sang $newLocation');
  }
}
