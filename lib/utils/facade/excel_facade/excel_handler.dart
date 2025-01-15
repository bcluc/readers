import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExcelHandler {
  // Lưu file Excel vào hệ thống
  static Future<File> saveExcel({
    required String name,
    required Excel excel,
  }) async {
    final bytes = await excel.encode(); // Mã hóa đối tượng Excel thành bytes

    final dir = await getApplicationDocumentsDirectory();

    final folderPath = '${dir.path}/ReaderLM Document';

    // Kiểm tra xem thư mục có tồn tại không
    if (!await Directory(folderPath).exists()) {
      // Nếu thư mục không tồn tại, tạo thư mục
      await Directory(folderPath).create();
    }

    // Đặt tên file và lưu tại thư mục đã tạo
    final file = File('${folderPath}/$name.xlsx');

    await file.writeAsBytes(bytes!); // Lưu bytes vào file

    return file; // Trả về file đã lưu
  }

  // Mở file Excel đã lưu
  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url); // Mở file với ứng dụng hỗ trợ Excel
  }
}
