import 'package:readers/utils/CoR/handler.dart';

abstract class ValidateMaDocGiaBaseHandler implements Handler {
  Handler? next;

  void setNext(Handler nextHandler) {
    next = nextHandler;
  }
}
