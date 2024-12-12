import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/utils/Export_file_strategy/export_file_strategy.dart';
import 'package:readers/utils/facade/excel_facade/excel_facade.dart';

class ExportFileExcelStrategy implements Exportfilestrategy {
  final ExcelFacade facade;
  ExportFileExcelStrategy(this.facade);
  @override
  void XuatPhieuMuon(String ngayMuon, String hanTra, String maDocGia, String hoTen, List<CuonSachDto2th> cuonSachs) {
     facade.generateAndOpenPhieuMuon(ngayMuon, hanTra, maDocGia, hoTen, cuonSachs);
  }
}