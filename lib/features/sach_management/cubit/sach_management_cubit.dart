import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readers/features/result_type.dart';
import 'package:readers/features/sach_management/cubit/sach_management_state.dart';
import 'package:readers/features/sach_management/data/sach_management_repository.dart';
import 'package:readers/models/sach.dart';

class SachManagementCubit extends Cubit<SachManagementState> {
  final SachManagementRepository sachManagementRepository;

  SachManagementCubit(this.sachManagementRepository)
      : super(SachManagementState());

  Future<void> getSachList() async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await sachManagementRepository.getSachList();
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            sachs: result.data,
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

  Future<void> addSach(Sach newSach) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await sachManagementRepository.addSach(newSach);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            sachs: [...?state.sachs, result.data],
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

  Future<void> contains(int maSach, List<Sach> sachs) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await sachManagementRepository.contains(maSach, sachs);
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

  Future<void> getTenDauSach(int maSach, List<Sach> sachs) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: "",
      ),
    );
    final result = await sachManagementRepository.getTenDauSach(maSach, sachs);
    return (switch (result) {
      Success() => emit(
          state.copyWith(
            isLoading: false,
            tenDauSach: result.data,
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
