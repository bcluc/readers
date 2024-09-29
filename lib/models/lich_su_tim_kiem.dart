class LichSuTimKiem {
  int searchTimestamp;
  String loaiTimKiem;
  String tuKhoa;

  LichSuTimKiem(
    this.searchTimestamp,
    this.loaiTimKiem,
    this.tuKhoa,
  );

  Map<String, dynamic> toMap() {
    return {
      'SearchTimestamp': searchTimestamp,
      'LoaiTimKiem': loaiTimKiem,
      'TuKhoa': tuKhoa,
    };
  }
}
