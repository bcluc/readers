import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';
import 'package:readers/main.dart';

class TacGiaManagementService {
  TacGiaManagementService();

  Future<List<TacGiaDto>> getTacGiaList() async {
    try {
      return await dbProcess.queryTacGiaDtos();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TacGiaDto> addTacGia(TacGiaDto newTacGia) async {
    try {
      int maTacGia = await dbProcess.insertTacGia(newTacGia.tenTacGia);
      newTacGia.maTacGia = maTacGia;
      return newTacGia;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> contains(int maSach, List<TacGiaDto> sachs) async {
    try {
      for (var sach in sachs) {
        if (sach.maTacGia == maSach) {
          return true;
        }
      }
      return false;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTacGia(int maTacGia) async {
    try {
      await dbProcess.deleteTacGiaWithMaTacGia(maTacGia);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTacGia(int maTacGia, String tenTacGia) async {
    try {
      return await dbProcess.updateTacGia(maTacGia, tenTacGia);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
