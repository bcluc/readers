import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/models/tac_gia.dart';

class SelectedTacGiaCubit extends Cubit<List<TacGia>> {
  SelectedTacGiaCubit() : super([]);
  /* secondary constructor */
  SelectedTacGiaCubit.of(List<TacGia> tacGias) : super(tacGias);

  void add(TacGia tacGia) => emit([...state, tacGia]);
  void remove(TacGia tacGia) {
    state.removeWhere(
      (element) => element.maTacGia == tacGia.maTacGia,
    );
    emit([...state]);
  }

  bool contains(TacGia needCheckTacGia) {
    for (var tacGia in state) {
      if (tacGia.maTacGia == needCheckTacGia.maTacGia) {
        return true;
      }
    }
    return false;
  }
}
