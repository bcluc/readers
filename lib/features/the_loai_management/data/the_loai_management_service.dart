import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';
import 'package:readers/main.dart';

class TheLoaiManagementService {
  TheLoaiManagementService();

  Future<List<TheLoaiDto>> getTheLoaiList() async {
    try {
      return await dbProcess.queryTheLoaiDtos();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<TheLoaiDto> addTheLoai(TheLoaiDto newTheLoai) async {
    try {
      int maTheLoai = await dbProcess.insertTheLoai(newTheLoai.tenTheLoai);
      newTheLoai.maTheLoai = maTheLoai;
      return newTheLoai;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> contains(int maSach, List<TheLoaiDto> sachs) async {
    try {
      for (var sach in sachs) {
        if (sach.maTheLoai == maSach) {
          return true;
        }
      }
      return false;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTheLoai(int maTheLoai) async {
    try {
      await dbProcess.deleteTheLoaiWithMaTheLoai(maTheLoai);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTheLoai(int maTheLoai, String tenTheLoai) async {
    try {
      return await dbProcess.updateTheLoai(maTheLoai, tenTheLoai);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
