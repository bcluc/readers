import 'package:readers/main.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';

class ValidateMDGExistHandler extends ValidateMaDocGiaBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    int maDocGia = int.parse(context['maDocGia']);
    String? hoTen = await dbProcess.queryHoTenDocGiaWithMaDocGia(maDocGia);

    if (hoTen == null) {
      context['error'] = 'Không tìm thấy Mã Độc Giả.';
      return;
    }
    context['hoTenDocGia'] = hoTen;
    if (next != null) {
      await next!.handle(context);
    }
  }
}
