import 'package:readers/main.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';

class ValidateNumOfBooksBorrowingHandler extends ValidateMaDocGiaBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    int maDocGia = int.parse(context['maDocGia']);
    int soSachDangMuon = await dbProcess.querySoSachDangMuonCuaDocGia(maDocGia);

    if (soSachDangMuon > 5) {
      context['error'] = 'Độc giả đã mượn quá 5 cuốn sách.';
      return;
    }

    if (next != null) {
      await next!.handle(context);
    }
  }
}
