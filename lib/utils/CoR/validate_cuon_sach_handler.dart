import 'package:readers/utils/CoR/save_phieu_muon_base_handler.dart';

class ValidateCuonSachHandler extends LuuPhieuMuonBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    List cuonSachs = context['cuonSachs'] ?? [];
    if (cuonSachs.isEmpty) {
      context['error'] = 'Bạn chưa chọn Cuốn Sách nào.';
      return;
    }

    if (next != null) {
      await next!.handle(context);
    }
  }
}
