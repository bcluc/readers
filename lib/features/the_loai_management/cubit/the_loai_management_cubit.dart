import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/features/result_type.dart';
import 'package:readers/features/the_loai_management/cubit/the_loai_management_state.dart';
import 'package:readers/features/the_loai_management/data/the_loai_management_repository.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';

class TheLoaiManagementCubit extends Cubit<TheLoaiManagementState> {
  final TheLoaiManagementRepository theLoaiManagementRepository;

  TheLoaiManagementCubit(this.theLoaiManagementRepository)
      : super(TheLoaiManagementState());

  Future<void> getTheLoaiList() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await theLoaiManagementRepository.getTheLoaiList();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            theLoais: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> addTheLoai(TheLoaiDto newTheLoai) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await theLoaiManagementRepository.addTheLoai(newTheLoai);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            theLoais: [...?state.theLoais, result.data],
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> contains(int maTheLoai, List<TheLoaiDto> theLoais) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result =
        await theLoaiManagementRepository.contains(maTheLoai, theLoais);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            isContains: result.data,
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
            isContains: false,
          ),
        ),
    });
  }

  Future<void> deleteTheLoai(int maTheLoai) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await theLoaiManagementRepository.deleteTheLoai(maTheLoai);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            theLoais: state.theLoais!
                .where((element) => element.maTheLoai != maTheLoai)
                .toList(),
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }

  Future<void> updateTheLoai(TheLoaiDto theLoai) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await theLoaiManagementRepository.updateTheLoai(
        theLoai.maTheLoai, theLoai.tenTheLoai);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            theLoais: state.theLoais!
                .map((e) => e.maTheLoai == theLoai.maTheLoai
                    ? TheLoaiDto(theLoai.maTheLoai, theLoai.tenTheLoai,
                        theLoai.soLuongSach)
                    : e)
                .toList(),
          ),
        ),
      Failure() => emit(
          state.copyWith(
            isLoading: false,
            errorMessage: result.message,
          ),
        ),
    });
  }
}
