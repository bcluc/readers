import 'dart:developer';
import 'package:readers/features/result_type.dart';
import 'package:readers/features/tac_gia_management/data/tac_gia_management_service.dart';
import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';

class TacGiaManagementRepository {
  final TacGiaManagementService tacGiaManagementService;

  TacGiaManagementRepository({
    required this.tacGiaManagementService,
  });

  Future<Result<List<TacGiaDto>>> getTacGiaList() async {
    try {
      return Success(await tacGiaManagementService.getTacGiaList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<TacGiaDto>> addTacGia(TacGiaDto newSach) async {
    try {
      return Success(await tacGiaManagementService.addTacGia(newSach));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> contains(int maSach, List<TacGiaDto> tacGias) async {
    try {
      return Success(await tacGiaManagementService.contains(maSach, tacGias));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<void>> deleteTacGia(int maTacGia) async {
    try {
      return Success(await tacGiaManagementService.deleteTacGia(maTacGia));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<void>> updateTacGia(int maTacGia, String tenTacGia) async {
    try {
      return Success(
          await tacGiaManagementService.updateTacGia(maTacGia, tenTacGia));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
