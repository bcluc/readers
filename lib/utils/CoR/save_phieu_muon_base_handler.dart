import 'package:readers/utils/CoR/handler.dart';

abstract class LuuPhieuMuonBaseHandler implements Handler {
  Handler? next;

  void setNext(Handler nextHandler) {
    next = nextHandler;
  }
}
