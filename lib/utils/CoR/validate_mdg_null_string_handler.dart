import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';

class ValidateMDGNullStringHandler extends ValidateMaDocGiaBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    String? maDocGia = context['maDocGia'];
    if (maDocGia == null || maDocGia.isEmpty) {
      context['error'] = 'Mã Độc Giả không được để trống.';
      return;
    }
    if (int.tryParse(maDocGia) == null) {
      context['error'] = 'Mã Độc Giả phải là một số.';
      return;
    }
    if (next != null) {
      await next!.handle(context);
    }
  }
}
