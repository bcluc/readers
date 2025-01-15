import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';

class TacGiaManagementState {
  final bool isLoading;
  final List<TacGiaDto>? tacGias;
  final String errorMessage;
  final bool isContains;

  TacGiaManagementState({
    this.isLoading = false,
    this.tacGias,
    this.errorMessage = "",
    this.isContains = false,
  });

  TacGiaManagementState copyWith({
    bool? isLoading,
    List<TacGiaDto>? tacGias,
    String? errorMessage,
    bool? isContains,
  }) {
    return TacGiaManagementState(
      isLoading: isLoading ?? this.isLoading,
      tacGias: tacGias ?? this.tacGias,
      errorMessage: errorMessage ?? this.errorMessage,
      isContains: isContains ?? this.isContains,
    );
  }
}
