abstract class BookStatusObserver {
  void onStatusChanged(String maCuonSach, String oldStatus, String newStatus);
  void onLocationChanged(String maCuonSach, String oldLocation, String newLocation);
}

class BookStatusSubject {
  final List<BookStatusObserver> _observers = [];

  void addObserver(BookStatusObserver observer) {
    _observers.add(observer);
  }

  void removeObserver(BookStatusObserver observer) {
    _observers.remove(observer);
  }

  void notifyStatusChanged(String maCuonSach, String oldStatus, String newStatus) {
    for (var observer in _observers) {
      observer.onStatusChanged(maCuonSach, oldStatus, newStatus);
    }
  }

  void notifyLocationChanged(String maCuonSach, String oldLocation, String newLocation) {
    for (var observer in _observers) {
      observer.onLocationChanged(maCuonSach, oldLocation, newLocation);
    }
  }
}
