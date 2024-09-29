import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/models/sach.dart';

class TatCaSachCubit extends Cubit<List<Sach>?> {
  TatCaSachCubit() : super(null);

  void setList(List<Sach> sachs) => emit(sachs);
  void addSach(Sach newSach) => emit([...state!, newSach]);

  bool get isEmpty => state!.isEmpty;
  bool contains(int maSach) {
    for (var sach in state!) {
      if (sach.maSach == maSach) {
        return true;
      }
    }
    return false;
  }

  String getTenDauSach(int maSach) {
    return state!.firstWhere((element) => element.maSach == maSach).tenDauSach;
  }
}
