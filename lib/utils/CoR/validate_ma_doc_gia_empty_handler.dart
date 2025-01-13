import 'package:readers/utils/CoR/save_phieu_muon_base_handler.dart';
import 'package:readers/utils/CoR/validate_expire_date_handler.dart';
import 'package:readers/utils/CoR/validate_ma_doc_gia_base_handler.dart';
import 'package:readers/utils/CoR/validate_mdg_exist_handler.dart';
import 'package:readers/utils/CoR/validate_mdg_null_string_handler.dart';

class ValidateMDGEmptyHandler extends LuuPhieuMuonBaseHandler {
  @override
  Future<void> handle(Map<String, dynamic> context) async {
    String? maDocGia = context['maDocGia'];
    if (maDocGia == null || maDocGia.isEmpty) {
      // Trigger SearchMaDocGia Chain
      ValidateMaDocGiaBaseHandler nullStringValidate =
          ValidateMDGNullStringHandler();
      ValidateMaDocGiaBaseHandler existValidate = ValidateMDGExistHandler();
      ValidateMaDocGiaBaseHandler expireValidate =
          ValidateMDGExpireDateHandler();
      nullStringValidate.setNext(existValidate);
      existValidate.setNext(expireValidate);

      await nullStringValidate.handle(context);
      if (context.containsKey('error')) {
        return;
      }
    }

    if (next != null) {
      await next!.handle(context);
    }
  }
}
