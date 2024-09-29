class TacGia {
  int? maTacGia;
  String tenTacGia;

  TacGia(
    this.maTacGia,
    this.tenTacGia,
  );

  Map<String, dynamic> toMap() {
    return {
      'MaTacGia': maTacGia,
      'TenTacGia': tenTacGia,
    };
  }
}
