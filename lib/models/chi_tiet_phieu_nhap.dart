class ChiTietPhieuNhap {
  int? maCTPN;
  int maSach;
  int? maPhieuNhap;
  int soLuong;
  int donGia;

  ChiTietPhieuNhap(
    this.maCTPN,
    this.maSach,
    this.maPhieuNhap,
    this.soLuong,
    this.donGia,
  );

  int get tongTien => donGia * soLuong;

  Map<String, dynamic> toMap() {
    return {
      'MaSach': maSach,
      'MaPhieuNhap': maPhieuNhap,
      'SoLuong': soLuong,
      'DonGia': donGia,
    };
  }
}
