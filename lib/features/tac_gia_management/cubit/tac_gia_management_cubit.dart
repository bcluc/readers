import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/features/result_type.dart';
import 'package:readers/features/tac_gia_management/cubit/tac_gia_management_state.dart';
import 'package:readers/features/tac_gia_management/data/tac_gia_management_repository.dart';
import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';

class TacGiaManagementCubit extends Cubit<TacGiaManagementState> {
  final TacGiaManagementRepository tacGiaManagementRepository;

  TacGiaManagementCubit(this.tacGiaManagementRepository)
      : super(TacGiaManagementState());

  Future<void> getTacGiaList() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await tacGiaManagementRepository.getTacGiaList();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            tacGias: result.data,
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

  Future<void> addTacGia(TacGiaDto newTacGia) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await tacGiaManagementRepository.addTacGia(newTacGia);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            tacGias: [...?state.tacGias, result.data],
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

  Future<void> contains(int maTacGia, List<TacGiaDto> tacGias) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await tacGiaManagementRepository.contains(maTacGia, tacGias);
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

  Future<void> deleteTacGia(int maTacGia) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await tacGiaManagementRepository.deleteTacGia(maTacGia);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            tacGias: state.tacGias!
                .where((element) => element.maTacGia != maTacGia)
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

  Future<void> updateTacGia(TacGiaDto tacGia) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await tacGiaManagementRepository.updateTacGia(
        tacGia.maTacGia!, tacGia.tenTacGia);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            tacGias: state.tacGias!
                .map((e) => e.maTacGia == tacGia.maTacGia
                    ? TacGiaDto(
                        tacGia.maTacGia, tacGia.tenTacGia, tacGia.soLuongSach)
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
