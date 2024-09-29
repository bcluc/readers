class Sach {
  int? maSach;
  int lanTaiBan;
  String nhaXuatBan;
  int maDauSach;
  String tenDauSach;

  Sach(
    this.maSach,
    this.lanTaiBan,
    this.nhaXuatBan,
    this.maDauSach,
    this.tenDauSach,
  );

  Map<String, dynamic> toMap() {
    return {
      'LanTaiBan': lanTaiBan,
      'NhaXuatBan': nhaXuatBan,
      'MaDauSach': maDauSach,
    };
  }
}
