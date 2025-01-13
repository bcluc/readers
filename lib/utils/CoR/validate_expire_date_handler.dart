import 'package:readers/main.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';

class ValidateMDGExpireDateHandler extends ValidateMaDocGiaBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    int maDocGia = int.parse(context['maDocGia']);
    bool isExpired = !await dbProcess.kiemTraHanTheDocGia(maDocGia);

    if (isExpired) {
      context['error'] = 'Thẻ Độc Giả đã hết hạn.';
      return;
    }
    if (next != null) {
      await next!.handle(context);
    }
  }
}
