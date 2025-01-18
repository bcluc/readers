import 'package:readers/main.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';

class ValidateBorrowingBooksReturnDateHandler
    extends ValidateMaDocGiaBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    int maDocGia = int.parse(context['maDocGia']);
    int soSachQuaHan = await dbProcess.querySoSachMuonQuahanCuaDocGia(maDocGia);

    if (soSachQuaHan > 0) {
      context['error'] = 'Độc giả có sách mượn quá hạn.';
      return;
    }

    if (next != null) {
      await next!.handle(context);
    }
  }
}
