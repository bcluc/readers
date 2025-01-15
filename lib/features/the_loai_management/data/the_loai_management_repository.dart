import 'dart:developer';
import 'package:readers/features/result_type.dart';
import 'package:readers/features/the_loai_management/data/the_loai_management_service.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';

class TheLoaiManagementRepository {
  final TheLoaiManagementService theLoaiManagementService;

  TheLoaiManagementRepository({
    required this.theLoaiManagementService,
  });

  Future<Result<List<TheLoaiDto>>> getTheLoaiList() async {
    try {
      return Success(await theLoaiManagementService.getTheLoaiList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<TheLoaiDto>> addTheLoai(TheLoaiDto newSach) async {
    try {
      return Success(await theLoaiManagementService.addTheLoai(newSach));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> contains(int maSach, List<TheLoaiDto> TheLoais) async {
    try {
      return Success(await theLoaiManagementService.contains(maSach, TheLoais));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<void>> deleteTheLoai(int maTheLoai) async {
    try {
      return Success(await theLoaiManagementService.deleteTheLoai(maTheLoai));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<void>> updateTheLoai(int maTheLoai, String tenTheLoai) async {
    try {
      return Success(
          await theLoaiManagementService.updateTheLoai(maTheLoai, tenTheLoai));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
