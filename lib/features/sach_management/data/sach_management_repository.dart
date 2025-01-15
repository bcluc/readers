import 'dart:developer';

import 'package:readers/features/result_type.dart';
import 'package:readers/features/sach_management/data/sach_management_service.dart';
import 'package:readers/models/sach.dart';

class SachManagementRepository {
  final SachManagementService sachManagementService;

  SachManagementRepository({
    required this.sachManagementService,
  });

  Future<Result<List<Sach>>> getSachList() async {
    try {
      return Success(await sachManagementService.getSachList());
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<Sach>> addSach(Sach newSach) async {
    try {
      return Success(await sachManagementService.addSach(newSach));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<bool>> contains(int maSach, List<Sach> sachs) async {
    try {
      return Success(await sachManagementService.contains(maSach, sachs));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }

  Future<Result<String>> getTenDauSach(int maSach, List<Sach> sachs) async {
    try {
      return Success(await sachManagementService.getTenDauSach(maSach, sachs));
    } catch (error) {
      log('$error');
      return Failure('$error');
    }
  }
}
