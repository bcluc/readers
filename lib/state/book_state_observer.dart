import 'package:readers/main.dart';
import 'package:readers/models/the_loai.dart';

// Observer interface
abstract class BookStateObserver {
  void onTheLoaiAdded(TheLoai theLoai);
  void onTheLoaiUpdated(TheLoai theLoai);
  void onTheLoaiDeleted(int maTheLoai);
  void onError(String error);
}

// State manager
class BookStateManager {
  static final BookStateManager _instance = BookStateManager._internal();
  factory BookStateManager() => _instance;
  BookStateManager._internal();

  final List<BookStateObserver> _observers = [];

  void addObserver(BookStateObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(BookStateObserver observer) {
    _observers.remove(observer);
  }

  Future<void> addTheLoai(TheLoai theLoai) async {
    try {
      // Add to database
      final returningId = await dbProcess.insertTheLoai(theLoai.tenTheLoai);
      final newTheLoai = theLoai.cloneWith(maTheLoai: returningId);

      // Notify all observers
      for (var observer in _observers) {
        observer.onTheLoaiAdded(newTheLoai);
      }
    } catch (e) {
      for (var observer in _observers) {
        observer.onError(e.toString());
      }
    }
  }

  Future<void> updateTheLoai(TheLoai theLoai) async {
    try {
      // Update in database
      await dbProcess.updateTheLoai(
          theLoai.maTheLoai as int, theLoai.tenTheLoai);

      // Notify observers
      for (var observer in _observers) {
        observer.onTheLoaiUpdated(theLoai);
      }
    } catch (e) {
      for (var observer in _observers) {
        observer.onError(e.toString());
      }
    }
  }
}
