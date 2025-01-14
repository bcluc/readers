import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfHandler {
  static Future<File> saveDocument({
    required String name,
    required Document pdfDoc,
  }) async {
    final bytes = await pdfDoc.save();

    final dir = await getApplicationDocumentsDirectory();

    final folderPath = '${dir.path}/ReaderLM Document';

    // Kiểm tra xem thư mục có tồn tại hay không
    if (!await Directory(folderPath).exists()) {
      // Nếu không tồn tại, tạo thư mục
      await Directory(folderPath).create();
    }

    final file = File('${dir.path}/ReaderLM Document/$name.pdf');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}