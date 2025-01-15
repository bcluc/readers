import 'package:readers/main.dart';
import 'package:readers/models/sach.dart';

class SachManagementService {
  SachManagementService();

  Future<List<Sach>> getSachList() async {
    try {
      return await dbProcess.querySach();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Sach> addSach(Sach newSach) async {
    try {
      int maSachMoi = await dbProcess.insertSach(newSach);
      newSach.maSach = maSachMoi;
      return newSach;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> contains(int maSach, List<Sach> sachs) async {
    try {
      for (var sach in sachs) {
        if (sach.maSach == maSach) {
          return true;
        }
      }
      return false;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getTenDauSach(int maSach, List<Sach> sachs) async {
    try {
      return sachs.firstWhere((element) => element.maSach == maSach).tenDauSach;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
