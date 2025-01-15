import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';

class TheLoaiManagementState {
  final bool isLoading;
  final List<TheLoaiDto>? theLoais;
  final String errorMessage;
  final bool isContains;

  TheLoaiManagementState({
    this.isLoading = false,
    this.theLoais,
    this.errorMessage = "",
    this.isContains = false,
  });

  TheLoaiManagementState copyWith({
    bool? isLoading,
    List<TheLoaiDto>? theLoais,
    String? errorMessage,
    bool? isContains,
  }) {
    return TheLoaiManagementState(
      isLoading: isLoading ?? this.isLoading,
      theLoais: theLoais ?? this.theLoais,
      errorMessage: errorMessage ?? this.errorMessage,
      isContains: isContains ?? this.isContains,
    );
  }
}
