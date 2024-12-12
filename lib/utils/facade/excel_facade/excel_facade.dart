import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/utils/facade/excel_facade/excel_generator.dart';
import 'package:readers/utils/facade/excel_facade/excel_handler.dart';

class ExcelFacade {
  static void generateAndOpenPhieuMuon(
    String ngayMuon,
    String hanTra,
    String maDocGia,
    String hoTen,
    List<CuonSachDto2th> cuonSachs,
  ) async {
    // Gọi hàm generate từ ExcelGenerator để tạo Excel document
    final phieuMuonExcel = await ExcelGenerator.generatePhieuMuon(
      maDocGia: maDocGia,
      hoTen: hoTen,
      ngayMuon: ngayMuon,
      hanTra: hanTra,
      cuonSachs: cuonSachs,
    );
    
    // Gọi hàm saveExcel từ ExcelHandler để lưu Excel document vào file
    final phieuMuonExcelFile = await ExcelHandler.saveExcel(
      name: removeDiacritics(hoTen).replaceAll(' ', '') +
          DateFormat('_ddMMyyyy_Hms').format(DateTime.now()),
      excel: phieuMuonExcel,
    );

    // Mở file Excel đã lưu
    ExcelHandler.openFile(phieuMuonExcelFile);
  }
}
