import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/models/the_loai.dart';

class SelectedTheLoaiCubit extends Cubit<List<TheLoai>> {
  SelectedTheLoaiCubit() : super([]);
  /* secondary constructor */
  SelectedTheLoaiCubit.of(List<TheLoai> theLoais) : super(theLoais);

  void add(TheLoai theLoai) => emit([...state, theLoai]);
  void remove(TheLoai theLoai) {
    state.removeWhere(
      (element) => element.maTheLoai == theLoai.maTheLoai,
    );
    emit([...state]);
  }

  bool contains(TheLoai needCheckTheLoai) {
    for (var theLoai in state) {
      if (theLoai.maTheLoai == needCheckTheLoai.maTheLoai) {
        return true;
      }
    }
    return false;
  }
}
