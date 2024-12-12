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

    // Định dạng tiêu đề
    sheet.appendRow(['Thư viện READER']);
    sheet.appendRow(['Địa chỉ: 506 Hùng Vương, Hội An, Quảng Nam']);
    sheet.appendRow(['Email: tvReader@gmail.com', 'SĐT: 0905743143']);
    sheet.appendRow(['']);
    sheet.appendRow(['PHIẾU MƯỢN']);
    sheet.appendRow(['']);

    // Thông tin người mượn
    sheet.appendRow(['Mã độc giả:', maDocGia]);
    sheet.appendRow(['Họ tên:', hoTen]);
    sheet.appendRow(['Ngày mượn:', ngayMuon]);
    sheet.appendRow(['Hạn trả:', hanTra]);
    sheet.appendRow(['Số lượng sách:', cuonSachs.length.toString()]);
    sheet.appendRow(['']);

    // Tiêu đề bảng sách
    final headers = [
      'Mã CS',
      'Tên Đầu sách',
      'Lần tái bản',
      'NXB',
      'Tác giả'
    ];
    sheet.appendRow(headers);

    // Dữ liệu sách
    for (var cuonSach in cuonSachs) {
      sheet.appendRow([
        cuonSach.maCuonSach,
        cuonSach.tenDauSach.capitalizeFirstLetterOfEachWord(),
        cuonSach.lanTaiBan,
        cuonSach.nhaXuatBan,
        cuonSach.tacGiasToString(),
      ]);
    }

    sheet.appendRow(['']);
    sheet.appendRow(['Vui lòng trả sách đúng hạn.']);
    sheet.appendRow([
      'Trong trường hợp vượt quá hạn trả, thư viện sẽ thu phí ' +
          ThamSoQuyDinh.mucThuTienPhat.toVnCurrencyFormat() +
          '/ngày/quyển.'
    ]);
    
    return excel;
  }
}
