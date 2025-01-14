import 'package:readers/dto/cuon_sach_dto_2th.dart';

abstract class Exportfilestrategy {
  void XuatPhieuMuon(
    String ngayMuon,
    String hanTra,
    String maDocGia,
    String hoTen,
    List<CuonSachDto2th> cuonSachs);
}