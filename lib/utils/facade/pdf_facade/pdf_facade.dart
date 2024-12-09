import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/utils/facade/pdf_facade/pdf_generator.dart';
import 'package:readers/utils/facade/pdf_facade/pdf_handler.dart';

class PdfFacade {
  static void generateAndOpenPhieuMuon(
    String ngayMuon,
    String hanTra,
    String maDocGia,
    String hoTen,
    List<CuonSachDto2th> cuonSachs,
  ) async {
    final phieuMuonDocument = await PdfGenerator.generatePhieuMuon(
      maDocGia: maDocGia,
      hoTen: hoTen,
      ngayMuon: ngayMuon,
      hanTra: hanTra,
      cuonSachs: cuonSachs,
    );
    final phieuMuonPdfFile = await PdfHandler.saveDocument(
      name: removeDiacritics(hoTen).replaceAll(' ', '') +
          DateFormat('_ddMMyyyy_Hms').format(DateTime.now()),
      pdfDoc: phieuMuonDocument,
    );

    PdfHandler.openFile(phieuMuonPdfFile);
  }
}
