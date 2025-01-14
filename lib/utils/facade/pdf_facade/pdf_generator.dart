import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static Future<Document> generatePhieuMuon({
    required String ngayMuon,
    required String hanTra,
    required String maDocGia,
    required String hoTen,
    required List<CuonSachDto2th> cuonSachs,
  }) async {
    final pdf = Document();

    final nunitoRegularFont = await PdfGoogleFonts.nunitoRegular();
    final nunitoBoldFont = await PdfGoogleFonts.nunitoBold();
    final nunitoItalicFont = await PdfGoogleFonts.nunitoItalic();

    final nunitoRegularTextStyle = pw.TextStyle(font: nunitoRegularFont);
    // final nunitoBoldTextStyle = pw.TextStyle(font: nunitoBoldFont);

    final img = await rootBundle.load('assets/logo/Asset_1.png');
    final imageBytes = img.buffer.asUint8List();

    final headers = [
      'Mã CS',
      'Tên Đầu sách',
      'Lần tái bản',
      'NXB',
      'Tác giả',
    ];

    final dataTable = cuonSachs
        .map(
          (cuonSach) => [
            cuonSach.maCuonSach,
            cuonSach.tenDauSach.capitalizeFirstLetterOfEachWord(),
            cuonSach.lanTaiBan,
            cuonSach.nhaXuatBan,
            cuonSach.tacGiasToString(),
          ],
        )
        .toList();

    pdf.addPage(
      pw.Page(
        /* A4: 21.0 * cm, 29.7 * cm, marginAll: 2.0 * cm */
        pageFormat: const PdfPageFormat(
          21.0 * PdfPageFormat.cm,
          29.7 * PdfPageFormat.cm,
          marginAll: 0,
        ),
        build: (context) {
          return Column(
            children: [
              pw.Container(
                color: PdfColor.fromHex('F9FAFC'),
                padding: const pw.EdgeInsets.all(15 * PdfPageFormat.mm),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        pw.Image(
                          pw.MemoryImage(imageBytes),
                          width: 44,
                        ),
                        pw.SizedBox(width: 7 * PdfPageFormat.mm),
                        pw.Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              ThamSoQuyDinh.tenThuVien,
                              style: nunitoRegularTextStyle,
                            ),
                            pw.SizedBox(
                              width: 8 * PdfPageFormat.cm,
                              child: pw.Text(
                                'Địa chỉ: ${ThamSoQuyDinh.diaChi}',
                                style: nunitoRegularTextStyle,
                              ),
                            ),
                          ],
                        ),
                        pw.Spacer(),
                        pw.Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Email: ${ThamSoQuyDinh.email}',
                              style: nunitoRegularTextStyle,
                            ),
                            pw.Text(
                              'SĐT: ${ThamSoQuyDinh.soDienThoai}',
                              style: nunitoRegularTextStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.SizedBox(
                      height: 8 * PdfPageFormat.mm,
                    ),
                    pw.Text(
                      'PHIẾU MƯỢN',
                      style: pw.TextStyle(
                        font: nunitoBoldFont,
                        fontSize: 12 * PdfPageFormat.mm,
                      ),
                    ),
                    pw.SizedBox(
                      height: 8 * PdfPageFormat.mm,
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'Mã độc giả: $maDocGia',
                            style: nunitoRegularTextStyle,
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'Họ tên: $hoTen',
                            style: nunitoRegularTextStyle,
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Số lượng: ${cuonSachs.length}',
                            style: nunitoRegularTextStyle,
                            textAlign: pw.TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'Ngày mượn: $ngayMuon',
                            style: nunitoRegularTextStyle,
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            'Hạn trả: $hanTra',
                            style: nunitoRegularTextStyle,
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  color: PdfColors.white,
                  padding: const pw.EdgeInsets.all(15 * PdfPageFormat.mm),
                  child: pw.Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      pw.TableHelper.fromTextArray(
                        headers: headers,
                        data: dataTable,
                        border: null,
                        headerStyle: TextStyle(
                          font: nunitoBoldFont,
                        ),
                        headerAlignments: {
                          0: pw.Alignment.centerLeft,
                          1: pw.Alignment.centerLeft,
                          2: pw.Alignment.centerLeft,
                          3: pw.Alignment.centerLeft,
                          4: pw.Alignment.centerLeft,
                        },
                        headerDecoration:
                            const pw.BoxDecoration(color: PdfColors.grey300),
                        cellHeight: 30,
                        cellStyle: nunitoRegularTextStyle,
                        cellAlignments: {
                          0: Alignment.centerLeft,
                          1: Alignment.centerLeft,
                          2: Alignment.centerLeft,
                          3: Alignment.centerLeft,
                          4: Alignment.centerLeft,
                        },
                        rowDecoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                                width: 1, color: PdfColors.grey200),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 5 * PdfPageFormat.mm),
                      pw.Text(
                        'Vui lòng trả sách đúng hạn.',
                        style: pw.TextStyle(font: nunitoItalicFont),
                      ),
                      pw.Text(
                        'Trong trường hợp vượt quá hạn trả, thư viện sẽ thu phí ${ThamSoQuyDinh.mucThuTienPhat.toVnCurrencyFormat()}/ngày/quyển.',
                        style: pw.TextStyle(font: nunitoItalicFont),
                      )
                    ],
                  ),
                ),
              ),
              /* Footer */
              pw.Container(
                color: PdfColor.fromHex('F9FAFC'),
                padding: const pw.EdgeInsets.all(15 * PdfPageFormat.mm),
                child: pw.Row(
                  children: [
                    pw.Text(
                      ThamSoQuyDinh.tenThuVien,
                      style: nunitoRegularTextStyle,
                    ),
                    pw.Spacer(),
                    pw.Text(
                      ThamSoQuyDinh.soDienThoai,
                      style: nunitoRegularTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }
}