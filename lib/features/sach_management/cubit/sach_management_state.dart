import 'package:readers/models/sach.dart';

class SachManagementState {
  final bool isLoading;
  final List<Sach>? sachs;
  final String errorMessage;
  final bool isContains;
  final String tenDauSach;

  SachManagementState({
    this.isLoading = false,
    this.sachs,
    this.errorMessage = "",
    this.isContains = false,
    this.tenDauSach = "",
  });

  SachManagementState copyWith({
    bool? isLoading,
    List<Sach>? sachs,
    String? errorMessage,
    bool? isContains,
    String? tenDauSach,
  }) {
    return SachManagementState(
      isLoading: isLoading ?? this.isLoading,
      sachs: sachs ?? this.sachs,
      errorMessage: errorMessage ?? this.errorMessage,
      isContains: isContains ?? this.isContains,
      tenDauSach: tenDauSach ?? this.tenDauSach,
    );
  }
}
