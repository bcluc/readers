import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';
import 'dart:io';

class ExcelGenerator {
  static Future<Excel> generatePhieuMuon({
    required String ngayMuon,
    required String hanTra,
    required String maDocGia,
    required String hoTen,
    required List<CuonSachDto2th> cuonSachs,
  }) async {
    var excel = Excel.createExcel();
    final sheet = excel['Phiếu Mượn'];

    // Set column widths
    sheet.setColWidth(0, 15);
    sheet.setColWidth(1, 40);
    sheet.setColWidth(2, 15);
    sheet.setColWidth(3, 25);
    sheet.setColWidth(4, 30);

    // Header styles
    var headerStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      fontSize: 16,
    );

    var subHeaderStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      fontSize: 12,
    );

    var titleStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      fontSize: 20,
    );

    var labelStyle = CellStyle(
      bold: true,
      fontSize: 12,
    );

    var tableHeaderStyle = CellStyle(
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
      backgroundColorHex: '#E7E6E6',
    );

    // Thư viện header
    var row = sheet.appendRow(['Thư viện READER']);
    var cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0));
    cell.value = 'Thư viện READER';
    cell.cellStyle = headerStyle;

    // Địa chỉ và thông tin liên hệ
    sheet.appendRow(['Địa chỉ: 506 Hùng Vương, Hội An, Quảng Nam']);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: 0));
    cell.cellStyle = subHeaderStyle;

    var contactRow = ['Email: tvReader@gmail.com', '', 'SĐT: 0905743143', '', ''];
    sheet.appendRow(contactRow);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 2, columnIndex: 0));
    cell.cellStyle = subHeaderStyle;

    sheet.appendRow(['']);

    // Tiêu đề PHIẾU MƯỢN
    sheet.appendRow(['PHIẾU MƯỢN']);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 4, columnIndex: 0));
    cell.value = 'PHIẾU MƯỢN';
    cell.cellStyle = titleStyle;

    sheet.appendRow(['']);

    // Thông tin người mượn với style
    var infoStyle = CellStyle(fontSize: 12);
    
    _appendInfoRow(sheet, 'Mã độc giả:', maDocGia, 6, labelStyle, infoStyle);
    _appendInfoRow(sheet, 'Họ tên:', hoTen, 7, labelStyle, infoStyle);
    _appendInfoRow(sheet, 'Ngày mượn:', ngayMuon, 8, labelStyle, infoStyle);
    _appendInfoRow(sheet, 'Hạn trả:', hanTra, 9, labelStyle, infoStyle);
    _appendInfoRow(sheet, 'Số lượng sách:', cuonSachs.length.toString(), 10, labelStyle, infoStyle);

    sheet.appendRow(['']);

    // Tiêu đề bảng sách với style
    final headers = ['Mã CS', 'Tên Đầu sách', 'Lần tái bản', 'NXB', 'Tác giả'];
    var headerRow = sheet.appendRow(headers);
    for (var i = 0; i < headers.length; i++) {
      cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: 12, columnIndex: i));
      cell.cellStyle = tableHeaderStyle;
    }

    // Dữ liệu sách với style
    var dataStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Left,
    );

    var currentRow = 13;
    for (var cuonSach in cuonSachs) {
      sheet.appendRow([
        cuonSach.maCuonSach,
        cuonSach.tenDauSach.capitalizeFirstLetterOfEachWord(),
        cuonSach.lanTaiBan,
        cuonSach.nhaXuatBan,
        cuonSach.tacGiasToString(),
      ]);
      
      for (var i = 0; i < 5; i++) {
        cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: i));
        cell.cellStyle = dataStyle;
      }
      currentRow++;
    }

    sheet.appendRow(['']);
    currentRow++;

    // Footer notes với style
    var noteStyle = CellStyle(
      italic: true,
      fontSize: 11,
      horizontalAlign: HorizontalAlign.Left,
    );

    sheet.appendRow(['Vui lòng trả sách đúng hạn.']);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: 0));
    cell.cellStyle = noteStyle;
    
    currentRow++;
    var phatRow = 'Trong trường hợp vượt quá hạn trả, thư viện sẽ thu phí ${ThamSoQuyDinh.mucThuTienPhat.toVnCurrencyFormat()}/ngày/quyển.';
    sheet.appendRow([phatRow]);
    cell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: 0));
    cell.cellStyle = noteStyle;

    return excel;
  }

  static void _appendInfoRow(Sheet sheet, String label, String value, int rowIndex, CellStyle labelStyle, CellStyle valueStyle) {
    sheet.appendRow([label, value]);
    var labelCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: rowIndex, columnIndex: 0));
    var valueCell = sheet.cell(CellIndex.indexByColumnRow(rowIndex: rowIndex, columnIndex: 1));
    labelCell.cellStyle = labelStyle;
    valueCell.cellStyle = valueStyle;
  }
}
