import 'dart:io';

import 'package:readers/dto/chi_tiet_phieu_nhap_dto.dart';
import 'package:readers/features/sach_management/dtos/cuon_sach_dto.dart';
import 'package:readers/dto/cuon_sach_dto_2th.dart';
import 'package:readers/dto/dau_sach_dto.dart';
import 'package:readers/dto/phieu_muon_can_tra_dto.dart';
import 'package:readers/dto/phieu_muon_dto.dart';
import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';
import 'package:readers/models/chi_tiet_phieu_nhap.dart';
import 'package:readers/models/dau_sach.dart';
import 'package:readers/models/doc_gia.dart';
import 'package:readers/models/lich_su_tim_kiem.dart';
import 'package:readers/models/phieu_muon.dart';
import 'package:readers/models/phieu_nhap.dart';
import 'package:readers/models/report_doc_gia.dart';
import 'package:readers/models/phieu_tra.dart';
import 'package:readers/models/report_sach.dart';
import 'package:readers/models/report_the_loai_muon.dart';
import 'package:readers/models/report_thu_nhap.dart';
import 'package:readers/models/sach.dart';
import 'package:readers/models/tac_gia.dart';
import 'package:readers/models/the_loai.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/parameters.dart';
import 'package:sqflite/utils/utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DbProcess {
  late Database _database;

  Future<void> connect() async {
    final currentFolder = Directory.current.path;
    _database = await openDatabase(
      '$currentFolder/database/library.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE TaiKhoan(
            username TEXT,
            password TEXT
          );

          INSERT INTO TaiKhoan VALUES('admin','123456'),
          ('PIN','qltv214');

          CREATE TABLE ThamSoQuyDinh(
            TenThuVien TEXT,
            DiaChi TEXT,
            SoDienThoai TEXT,
            Email TEXT,
            SoNgayMuonToiDa INTEGER,    -- 30 ngay
            SoSachMuonToiDa INTEGER,    -- 5 cuon
            MucThuTienPhat INTEGER,     -- 10000
            TuoiToiThieu INTEGER,       -- 12 tuoi
            PhiTaoThe INTEGER,          -- 50000
            ThoiHanThe INTEGER          -- 3 thang
                           
          );

          INSERT INTO ThamSoQuyDinh 
          VALUES('Thư viện READER', '506 Hùng Vương, Hội An, Quảng Nam', '0905743143', 'tvReader@gmail.com', '30','5', '2000', '12', '50000', 3);

          CREATE TABLE TacGia(
            MaTacGia INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTacGia TEXT
          );
          
          CREATE TABLE DauSach(
            MaDauSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenDauSach TEXT
          );

          CREATE TABLE TacGia_DauSach (
            MaTacGia INTEGER,
            MaDauSach INTEGER,
            PRIMARY KEY (MaTacGia, MaDauSach),

            FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE,
            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE CASCADE
          );

          CREATE TABLE TheLoai(
            MaTheLoai INTEGER PRIMARY KEY AUTOINCREMENT, 
            TenTheLoai TEXT
          );

          CREATE TABLE DauSach_TheLoai(
            MaDauSach INTEGER,
            MaTheLoai INTEGER,

            PRIMARY KEY (MaDauSach, MaTheLoai),

            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE CASCADE,
            FOREIGN KEY (MaTheLoai) REFERENCES TheLoai(MaTheLoai) ON DELETE CASCADE
          );

          CREATE TABLE Sach(
            MaSach INTEGER PRIMARY KEY AUTOINCREMENT, 
            LanTaiBan INTEGER,
            NhaXuatBan TEXT,
            -- NamXuatBan INTEGER,
            MaDauSach INTEGER,

            FOREIGN KEY (MaDauSach) REFERENCES DauSach(MaDauSach) ON DELETE RESTRICT
          );

          -- CREATE TABLE NhaCungCap(
          --   MaNCC INTEGER PRIMARY KEY AUTOINCREMENT, 
          --   TenNCC TEXT,
          --   SoDienThoai TEXT
          -- );

          CREATE TABLE PhieuNhap(
            MaPhieuNhap INTEGER PRIMARY KEY AUTOINCREMENT, 
            NgayLap TEXT
            -- MaNCC INTEGER

            -- FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC) ON DELETE RESTRICT
          );

          CREATE TABLE CT_PhieuNhap(
            MaCTPN INTEGER PRIMARY KEY AUTOINCREMENT, 
            MaPhieuNhap INTEGER,
            MaSach INTEGER,
            SoLuong INTEGER,
            DonGia INTEGER,

            FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhap(MaPhieuNhap) ON DELETE RESTRICT,
            FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE RESTRICT
          );

          CREATE TABLE CuonSach(
            MaCuonSach TEXT PRIMARY KEY,
            TinhTrang INTEGER,
            ViTri TEXT,
            MaCTPN INTEGER,
            MaSach INTEGER,

            FOREIGN KEY (MaCTPN) REFERENCES CT_PhieuNhap(MaCTPN) ON DELETE RESTRICT,
            FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE RESTRICT
          );

          CREATE TABLE DocGia(
            MaDocGia INTEGER PRIMARY KEY AUTOINCREMENT,
            HoTen TEXT,
            NgaySinh TEXT,
            DiaChi TEXT,
            SoDienThoai TEXT,
            NgayLapThe TEXT,
            NgayHetHan TEXT
          );

          CREATE TABLE PhieuMuon(
            MaPhieuMuon INTEGER PRIMARY KEY AUTOINCREMENT,
            MaCuonSach TEXT,
            MaDocGia INTEGER,
            NgayMuon TEXT,
            HanTra TEXT,
            TinhTrang TEXT,

            FOREIGN KEY (MaCuonSach) REFERENCES CuonSach(MaCuonSach) ON DELETE RESTRICT,
            FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia) ON DELETE RESTRICT
          );

          CREATE TABLE PhieuTra(
            MaPhieuTra INTEGER PRIMARY KEY AUTOINCREMENT,
            MaPhieuMuon INTEGER,
            NgayTra TEXT,
            SoTienPhat INTEGER,

            FOREIGN KEY (MaPhieuMuon) REFERENCES PhieuMuon(MaPhieuMuon) ON DELETE RESTRICT
          );

          CREATE TABLE LichSuTimKiem(
            SearchTimestamp INT PRIMARY KEY,
            LoaiTimKiem TEXT,
            TuKhoa TEXT
          );

          CREATE TABLE CT_TaoThe(
            MaCTTT INTEGER PRIMARY KEY AUTOINCREMENT, 
            MaDocGia INTERGER,
            PhiTaoThe INTERGER,
            NgayTao TEXT,

            FOREIGN KEY (MaDocGia) REFERENCES DocGia(MaDocGia) ON DELETE RESTRICT
          );
        ''',
        );
      },
    );
  }

  /* PIN CODE */
  Future<String> queryPinCode() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      "select * from TaiKhoan where username = 'PIN'",
    );
    return data.first['password'];
  }

  Future<void> updateMaPin(String newMaPin) async {
    await _database.rawUpdate(
      '''
      update TaiKhoan
      set password = ?
      where username = 'PIN'
      ''',
      [newMaPin],
    );
  }

  /* ACCOUNT CODE */
  Future<Map<String, dynamic>> queryAccount() async {
    List<Map<String, dynamic>> data =
        await _database.rawQuery('select * from TaiKhoan');
    return data.first;
  }

  Future<void> updateAdminPassword(String newPassword) async {
    await _database.rawUpdate(
      '''
      update TaiKhoan
      set password = ?
      where username = 'admin'
      ''',
      [newPassword],
    );
  }

  /* THAM SỐ CODE */
  Future<Map<String, dynamic>> queryThamSoQuyDinh() async {
    List<Map<String, dynamic>> data =
        await _database.rawQuery('select * from ThamSoQuyDinh');
    return data.first;
  }

  Future<void> updateGiaTriThamSo(
      {required String thamSo, required String giaTri}) async {
    await _database.rawUpdate(
      '''
      update ThamSoQuyDinh
      set $thamSo = ?
      ''',
      [giaTri],
    );
  }

  // ĐỘC GIẢ CODE
  Future<List<DocGia>> queryDocGia({
    required int numberRowIgnore,
  }) async {
    /* Lấy 8 dòng dữ liệu Độc Giả được thêm gần đây */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DocGia 
      limit ?, 8
      ''',
      [numberRowIgnore],
    );

    List<DocGia> danhSachDocGia = [];

    for (var element in data) {
      danhSachDocGia.add(
        DocGia(
          element['MaDocGia'],
          element['HoTen'],
          vnDateFormat.parse(element['NgaySinh'] as String),
          element['DiaChi'],
          element['SoDienThoai'],
          vnDateFormat.parse(element['NgayLapThe'] as String),
          vnDateFormat.parse(element['NgayHetHan'] as String),
        ),
      );
    }

    return danhSachDocGia;
  }

  Future<String?> queryHoTenDocGiaWithMaDocGia(int maDocGia) async {
    final res = (await _database.rawQuery(
      '''
      select HoTen from DocGia 
      where MaDocGia = ?
      ''',
      [maDocGia],
    ));
    if (res.isEmpty) {
      return null;
    }
    return res.first['HoTen'] as String;
  }

  Future<List<DocGia>> queryDocGiaFullnameWithString({
    required String str,
    required int numberRowIgnore,
  }) async {
    /* Lấy 10 dòng dữ liệu Độc Giả được thêm gần đây */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DocGia 
      where HoTen like ? or SoDienThoai like ?
      limit ?, 8
      ''',
      ['%$str%', '%$str%', numberRowIgnore],
    );
    List<DocGia> docGias = [];

    for (var element in data) {
      docGias.add(
        DocGia(
          element['MaDocGia'],
          element['HoTen'],
          vnDateFormat.parse(element['NgaySinh'] as String),
          element['DiaChi'],
          element['SoDienThoai'],
          vnDateFormat.parse(element['NgayLapThe'] as String),
          vnDateFormat.parse(element['NgayHetHan'] as String),
        ),
      );
    }

    return docGias;
  }

  Future<int> queryCountDocGia() async {
    return firstIntValue(
        await _database.rawQuery('select count(MaDocGia) from DocGia'))!;
  }

  Future<int> queryCountDocGiaFullnameWithString(String str) async {
    return firstIntValue(
      await _database.rawQuery(
        '''
          select count(MaDocGia) from DocGia 
          where Hoten like ?
          ''',
        ['%${str.toLowerCase()}%'],
      ),
    )!;
  }

  Future<int> insertDocGia(DocGia newDocGia) async {
    int maDocGia = await _database.insert('DocGia', newDocGia.toMap());
    await _database.insert('CT_TaoThe', {
      'MaDocGia': maDocGia,
      'PhiTaoThe': ThamSoQuyDinh.phiTaoThe,
      'NgayTao': DateTime.now().toVnFormat(),
    });
    return maDocGia;
  }

  Future<void> deleteDocGia(int maDocGia) async {
    await _database
        .rawDelete('delete from DocGia where MaDocGia  = ?', [maDocGia]);
  }

  Future<void> updateDocGia(DocGia updatedDocGia) async {
    await _database.rawUpdate(
      '''
      update DocGia 
      set HoTen = ?, NgaySinh = ?, DiaChi = ?, SoDienThoai = ?, 
      NgayLapThe = ?, NgayHetHan = ?
      where MaDocGia  = ?
      ''',
      [
        updatedDocGia.hoTen,
        updatedDocGia.ngaySinh.toVnFormat(),
        updatedDocGia.diaChi,
        updatedDocGia.soDienThoai,
        updatedDocGia.ngayLapThe.toVnFormat(),
        updatedDocGia.ngayHetHan.toVnFormat(),
        updatedDocGia.maDocGia,
      ],
    );
  }

  Future<bool> kiemTraHanTheDocGia(int maDocGia) async {
    final res = await _database.rawQuery(
      '''
        select NgayHetHan from DocGia 
        where MaDocGia = ?
        ''',
      [maDocGia],
    );

    final ngayHetHan = vnDateFormat.parse(res[0]['NgayHetHan'] as String);
    return ngayHetHan.endOfDay().isAfter(DateTime.now());
  }

  /* ĐẦU SÁCH CODE */
  Future<List<DauSach>> queryDauSach() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DauSach 
      ''',
    );

    List<DauSach> dauSachs = [];

    for (var element in data) {
      dauSachs.add(
        DauSach(
          element['MaDauSach'],
          element['TenDauSach'],
        ),
      );
    }

    return dauSachs;
  }

  Future<List<DauSachDto>> queryDauSachDto() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from DauSach 
      ''',
    );

    List<DauSachDto> dauSachs = [];

    for (var element in data) {
      final dauSach = DauSachDto(
        element['MaDauSach'],
        element['TenDauSach'],
        0,
        [],
        [],
      );

      QueryCursor cur = await _database.rawQueryCursor(
        '''
        select sum(SoLuong) as SoLuong
        from DauSach join Sach using(MaDauSach)
        join CT_PhieuNhap using(MaSach)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      await cur.moveNext();
      int? soLuong = cur.current['SoLuong'] as int?;
      dauSach.soLuong = soLuong ?? 0;
      cur.moveNext();

      cur = await _database.rawQueryCursor(
        '''
        select MaTacGia, TenTacGia from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      while (await cur.moveNext()) {
        dauSach.tacGias.add(
          TacGia(
            cur.current['MaTacGia'] as int,
            cur.current['TenTacGia'] as String,
          ),
        );
      }

      cur = await _database.rawQueryCursor(
        '''
        select MaTheLoai, TenTheLoai from DauSach_TheLoai join TheLoai USING(MaTheLoai)
        where MaDauSach = ?
        ''',
        [dauSach.maDauSach],
      );

      while (await cur.moveNext()) {
        dauSach.theLoais.add(
          TheLoai(
            cur.current['MaTheLoai'] as int,
            cur.current['TenTheLoai'] as String,
          ),
        );
      }

      dauSachs.add(dauSach);
    }

    return dauSachs;
  }

  Future<List<String>> queryDauSachWithMaTacGia(int maTacGia) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select TenDauSach
      from DauSach join TacGia_DauSach using(MaDauSach)
      where MaTacGia = ?
      ''',
      [maTacGia],
    );

    List<String> dauSachs = [];

    for (var element in data) {
      dauSachs.add(
        element['TenDauSach'],
      );
    }

    return dauSachs;
  }

  Future<List<String>> queryDauSachWithMaTheLoai(int maTheLoai) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select TenDauSach
      from DauSach join DauSach_TheLoai using(MaDauSach)
      where MaTheLoai = ?
      ''',
      [maTheLoai],
    );

    List<String> dauSachs = [];

    for (var element in data) {
      dauSachs.add(
        element['TenDauSach'],
      );
    }

    return dauSachs;
  }

  Future<int> insertDauSach(DauSach newDauSach) async {
    return await _database.insert(
      'DauSach',
      {
        'TenDauSach': newDauSach.tenDauSach,
      },
    );
  }

  Future<int> insertDauSachDto(DauSachDto newDauSachDto) async {
    // Insert Đầu sách
    int returningId = await _database.insert(
      'DauSach',
      {
        'TenDauSach': newDauSachDto.tenDauSach,
      },
    );

    // Insert TacGia_DauSach
    for (var tacGia in newDauSachDto.tacGias) {
      await _database.insert(
        'TacGia_DauSach',
        {
          'MaTacGia': tacGia.maTacGia,
          'MaDauSach': returningId,
        },
      );
    }

    // Insert DauSach_TheLoai
    for (var theLoai in newDauSachDto.theLoais) {
      await _database.insert(
        'DauSach_TheLoai',
        {
          'MaTheLoai': theLoai.maTheLoai,
          'MaDauSach': returningId,
        },
      );
    }

    return returningId;
  }

  Future<void> updateDauSachDto(DauSachDto updatedDauSachDto) async {
    /* Delete các Tác giả cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from TacGia_DauSach
      where MaDauSach = ?
      ''',
      [updatedDauSachDto.maDauSach],
    );
    /* Delete các Thể loại cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from DauSach_TheLoai
      where MaDauSach = ?
      ''',
      [updatedDauSachDto.maDauSach],
    );
    /* Cập nhật tên Đầu Sách */
    await _database.rawUpdate(
      '''
      update DauSach
      set TenDauSach = ?
      where MaDauSach = ?
      ''',
      [
        updatedDauSachDto.tenDauSach,
        updatedDauSachDto.maDauSach,
      ],
    );
    /* Thêm mới các Tác giả */
    for (var tacGia in updatedDauSachDto.tacGias) {
      await _database.insert(
        'TacGia_DauSach',
        {
          'MaTacGia': tacGia.maTacGia,
          'MaDauSach': updatedDauSachDto.maDauSach,
        },
      );
    }
    /* Thêm mới các Thể loại */
    for (var theLoai in updatedDauSachDto.theLoais) {
      await _database.insert(
        'DauSach_TheLoai',
        {
          'MaTheLoai': theLoai.maTheLoai,
          'MaDauSach': updatedDauSachDto.maDauSach,
        },
      );
    }
    /* DONE */
  }

  Future<void> deleteDauSachWithId(int maDauSach) async {
    /* 
    Vì ON DELETE CASCADE không hoạt động trong flutter 

    Nhưng khi delete DauSach trong DB Brower for SQLite thì ON DELETE CASCADE lại hoạt động, 
    nó tự động xoát các dòng liên quan trong bảng TacGia_DauSach, DauSach_TheLoai )

    => Vậy nên, phải tự delete thủ công trong Flutter 
    */
    /* Delete các Tác giả cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from TacGia_DauSach
      where MaDauSach = ?
      ''',
      [maDauSach],
    );
    /* Delete các Thể loại cũ đang gắn với Đầu sách */
    await _database.rawDelete(
      '''
      delete from DauSach_TheLoai
      where MaDauSach = ?
      ''',
      [maDauSach],
    );
    /* Delete Đầu Sách */
    await _database.rawDelete(
      '''
      delete from DauSach
      where MaDauSach = ?
      ''',
      [maDauSach],
    );
  }

  /* SACH CODE */
  Future<List<Sach>> querySach() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from Sach join DauSach using(MaDauSach)
      ''',
    );

    List<Sach> sachs = [];

    for (var element in data) {
      sachs.add(
        Sach(
          element['MaSach'],
          element['LanTaiBan'],
          element['NhaXuatBan'],
          element['MaDauSach'],
          element['TenDauSach'],
        ),
      );
    }

    return sachs;
  }

  Future<int> insertSach(Sach newSach) async {
    return await _database.insert(
      'Sach',
      newSach.toMap(),
    );
  }

  /* PHIEU NHAP CODE */
  Future<List<PhieuNhap>> queryPhieuNhap() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select PhieuNhap.MaPhieuNhap, NgayLap, SUM(SoLuong * DonGia) as TongTien
      from PhieuNhap join CT_PhieuNhap using(MaPhieuNhap)
      group by MaPhieuNhap
      ''',
    );

    List<PhieuNhap> phieuNhaps = [];

    for (var element in data) {
      phieuNhaps.add(
        PhieuNhap(
          element['MaPhieuNhap'],
          vnDateFormat.parse(element['NgayLap']),
          element['TongTien'],
        ),
      );
    }

    return phieuNhaps;
  }

  Future<int> insertPhieuNhap(PhieuNhap newPhieuNhap) async {
    // print("INSERT INTO PhieuNhap(NgayLap) VALUES ('${newPhieuNhap.ngayLap.toVnFormat()}');");

    return await _database.insert(
      'PhieuNhap',
      newPhieuNhap.toMap(),
    );
  }

  Future<void> updateNgayLapPhieuNhap(PhieuNhap updatedPhieuNhap) async {
    await _database.rawUpdate('''
      update PhieuNhap
      set NgayLap = ?
      where MaPhieuNhap = ?
      ''', [
      updatedPhieuNhap.ngayLap.toVnFormat(),
      updatedPhieuNhap.maPhieuNhap,
    ]);
  }

  /* CHI TIET PHIEU NHAP CODE */
  Future<List<ChiTietPhieuNhapDto>> queryChiTietPhieuNhapDtoWithMaPhieuNhap(
      int maPhieuNhap) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCTPN, TenDauSach, MaSach, SoLuong, DonGia from CT_PhieuNhap 
      join Sach using(MaSach) 
      join DauSach using(MaDauSach)
      where MaPhieuNhap = ?
      ''',
      [maPhieuNhap],
    );

    List<ChiTietPhieuNhapDto> phieuNhaps = [];

    for (var element in data) {
      phieuNhaps.add(
        ChiTietPhieuNhapDto(
          element['MaCTPN'],
          element['TenDauSach'],
          element['MaSach'],
          element['SoLuong'],
          element['DonGia'],
        ),
      );
    }

    return phieuNhaps;
  }

  Future<int> insertChiTietPhieuNhap(
      ChiTietPhieuNhap newChiTietPhieuNhap) async {
    // print(
    //     "INSERT INTO CT_PhieuNhap(MaPhieuNhap, MaSach, SoLuong, DonGia) VALUES ('${newChiTietPhieuNhap.maPhieuNhap}', '${newChiTietPhieuNhap.maSach}', '${newChiTietPhieuNhap.soLuong}', '${newChiTietPhieuNhap.donGia}');");

    int returningId = await _database.insert(
      'CT_PhieuNhap',
      newChiTietPhieuNhap.toMap(),
    );

    for (int i = 1; i <= newChiTietPhieuNhap.soLuong; ++i) {
      // print(
      //     "INSERT INTO CuonSach(MaCuonSach, TinhTrang, ViTri, MaCTPN, MaSach) VALUES ('${newChiTietPhieuNhap.maSach}_${returningId}_$i', 'Có sẵn', '', '$returningId', '${newChiTietPhieuNhap.maSach}');");

      await _database.insert(
        'CuonSach',
        {
          'MaCuonSach': '${newChiTietPhieuNhap.maSach}$returningId$i',
          'TinhTrang': 'Có sẵn',
          'ViTri': 'Chưa có thông tin',
          'MaCTPN': returningId,
          'MaSach': newChiTietPhieuNhap.maSach,
        },
      );
    }

    return returningId;
  }

  // 311  531 282 144 771

  Future<void> updateSoLuongChiTietPhieuNhap(
      ChiTietPhieuNhapDto updatedChiTietPhieuNhap) async {
    /* Xóa các cuốn sách có liên quan đến ChiTietPhieuNhap này */
    await _database.rawDelete(
      '''
      delete from CuonSach
      where MaCTPN = ?
      ''',
      [updatedChiTietPhieuNhap.maCTPN],
    );

    /* Cập nhật lại số lượng cho ChiTietPhieuNhap này */
    await _database.rawUpdate(
      '''
      update CT_PhieuNhap
      set SoLuong = ?
      where MaCTPN = ?
      ''',
      [
        updatedChiTietPhieuNhap.soLuong,
        updatedChiTietPhieuNhap.maCTPN,
      ],
    );

    /* Thêm lại các CuonSach với số lượng mới */
    for (int i = 1; i <= updatedChiTietPhieuNhap.soLuong; ++i) {
      await _database.insert(
        'CuonSach',
        {
          'MaCuonSach':
              '${updatedChiTietPhieuNhap.maSach}${updatedChiTietPhieuNhap.maCTPN}$i',
          'TinhTrang': 'Có sẵn',
          'ViTri': 'Chưa có thông tin',
          'MaCTPN': updatedChiTietPhieuNhap.maCTPN,
          'MaSach': updatedChiTietPhieuNhap.maSach,
        },
      );
    }
  }

  Future<void> updateDonGiaChiTietPhieuNhap(
      ChiTietPhieuNhapDto updatedChiTietPhieuNhap) async {
    /* Cập nhật lại Đơn Giá cho ChiTietPhieuNhap này */
    await _database.rawUpdate(
      '''
      update CT_PhieuNhap
      set DonGia = ?
      where MaCTPN = ?
      ''',
      [
        updatedChiTietPhieuNhap.donGia,
        updatedChiTietPhieuNhap.maCTPN,
      ],
    );
  }

  /* TÁC GIẢ CODE */
  Future<List<TacGia>> queryTacGias() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TacGia;
      ''',
    );

    List<TacGia> tacGias = [];

    for (var element in data) {
      tacGias.add(
        TacGia(
          element['MaTacGia'],
          element['TenTacGia'],
        ),
      );
    }

    return tacGias;
  }

  Future<List<TacGiaDto>> queryTacGiaDtos() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TacGia;
      ''',
    );

    List<TacGiaDto> tacGias = [];

    for (var element in data) {
      final tacGia = TacGiaDto(
        element['MaTacGia'],
        element['TenTacGia'],
        0,
      );

      List<Map<String, dynamic>> soLuongSachData = await _database.rawQuery(
        '''
        select count(MaDauSach) as SoLuong
        from TacGia_DauSach
        where MaTacGia = ?
        ''',
        [tacGia.maTacGia],
      );

      if (soLuongSachData.isNotEmpty) {
        tacGia.soLuongSach = soLuongSachData[0]['SoLuong'];
      }

      tacGias.add(tacGia);
    }

    return tacGias;
  }

  Future<int> insertTacGia(String tenTacGia) async {
    return await _database.insert(
      'TacGia',
      {
        'TenTacGia': tenTacGia,
      },
    );
  }

  Future<void> updateTacGia(int maTacGia, String tenTacGia) async {
    await _database.rawUpdate(
      '''
      update TacGia
      set TenTacGia = ?
      where MaTacGia = ?
      ''',
      [
        tenTacGia,
        maTacGia,
      ],
    );
  }

  Future<void> deleteTacGiaWithMaTacGia(int maTacGia) async {
    /* Delete TacGia_DauSach có liên quan */
    await _database.rawDelete(
      '''
      delete from TacGia_DauSach
      where MaTacGia = ?
      ''',
      [maTacGia],
    );

    /* Delete TacGia */
    await _database.rawDelete(
      '''
      delete from TacGia 
      where MaTacGia = ?
      ''',
      [maTacGia],
    );
  }

  /* THỂ LOẠI CODE */

  Future<List<TheLoai>> queryTheLoais() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TheLoai;
      ''',
    );

    List<TheLoai> theLoais = [];

    for (var element in data) {
      theLoais.add(
        TheLoai(
          element['MaTheLoai'],
          element['TenTheLoai'],
        ),
      );
    }

    return theLoais;
  }

  Future<List<TheLoaiDto>> queryTheLoaiDtos() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from TheLoai;
      ''',
    );

    List<TheLoaiDto> theLoais = [];

    for (var element in data) {
      final theLoai = TheLoaiDto(
        element['MaTheLoai'],
        element['TenTheLoai'],
        0,
      );

      List<Map<String, dynamic>> soLuongSachData = await _database.rawQuery(
        '''
        select count(MaDauSach) as SoLuong
        from DauSach_TheLoai
        where MaTheLoai = ?
        ''',
        [theLoai.maTheLoai],
      );

      if (soLuongSachData.isNotEmpty) {
        theLoai.soLuongSach = soLuongSachData[0]['SoLuong'];
      }

      theLoais.add(theLoai);
    }

    return theLoais;
  }

  Future<int> insertTheLoai(String tenTheLoai) async {
    return await _database.insert(
      'TheLoai',
      {
        'TenTheLoai': tenTheLoai,
      },
    );
  }

  Future<void> updateTheLoai(int maTheLoai, String tenTheLoai) async {
    await _database.rawUpdate(
      '''
      update TheLoai
      set TenTheLoai = ?
      where MaTheLoai = ?
      ''',
      [
        tenTheLoai,
        maTheLoai,
      ],
    );
  }

  Future<void> deleteTheLoaiWithMaTheLoai(int maTheLoai) async {
    /* Delete DauSach_TheLoai có liên quan */
    await _database.rawDelete(
      '''
      delete from DauSach_TheLoai
      where MaTheLoai = ?
      ''',
      [maTheLoai],
    );

    /* Delete TheLoai */
    await _database.rawDelete(
      '''
      delete from TheLoai 
      where MaTheLoai = ?
      ''',
      [maTheLoai],
    );
  }

  /* LỊCH SỬ TÌM KIẾM CUỐN SÁCH CODE */
  Future<List<LichSuTimKiem>> queryLichSuTimKiem(
      {required String loaiTimKiem}) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select * from LichSuTimKiem
      where LoaiTimKiem = ?
      order by SearchTimestamp desc
      ''',
      [loaiTimKiem],
    );

    List<LichSuTimKiem> lichSuTimKiem = [];

    for (var element in data) {
      lichSuTimKiem.add(
        LichSuTimKiem(
          element['SearchTimestamp'],
          loaiTimKiem,
          element['TuKhoa'],
        ),
      );
    }

    return lichSuTimKiem;
  }

  Future<void> insertLichSuTimKiem(LichSuTimKiem lichSuTimKiemCuonSach) async {
    await _database.insert(
      'LichSuTimKiem',
      lichSuTimKiemCuonSach.toMap(),
    );
  }

  Future<void> updateSearchTimestampLichSuTimKiem(
      LichSuTimKiem updatedLichSuTimKiemCuonSach) async {
    await _database.rawUpdate(
      '''
      update LichSuTimKiem
      set SearchTimestamp = ?
      where TuKhoa = ?
      ''',
      [
        updatedLichSuTimKiemCuonSach.searchTimestamp,
        updatedLichSuTimKiemCuonSach.tuKhoa,
      ],
    );
  }

  Future<void> deleteLichSuTimKiem(LichSuTimKiem lichSuTimKiemCuonSach) async {
    await _database.rawDelete(
      '''
      delete from LichSuTimKiem
      where SearchTimestamp = ?
      ''',
      [lichSuTimKiemCuonSach.searchTimestamp],
    );
  }

  /* CUỐN SÁCH CODE */
  Future<List<CuonSachDto>> queryCuonSachDtoWithKeyword(String keyword) async {
    /* 
    Truy vấn các cuốn sách có MaCuonSach hoặc TenDauSach chứa keyword
    */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCuonSach, TenDauSach, LanTaiBan, NhaXuatBan, TinhTrang, ViTri, MaCTPN
      from DauSach join Sach using(MaDauSach) 
      join CT_PhieuNhap using(MaSach)
      join CuonSach using(MaSach, MaCTPN)
      where TenDauSach like ? or MaCuonSach like ?
      ''',
      [
        '%${keyword.toLowerCase()}%',
        '%${keyword.toLowerCase()}%',
      ],
    );

    List<CuonSachDto> cuonSachs = [];

    for (var element in data) {
      cuonSachs.add(
        CuonSachDto(
          element['MaCuonSach'],
          element['TenDauSach'],
          element['LanTaiBan'],
          element['NhaXuatBan'],
          element['TinhTrang'],
          element['ViTri'],
          element['MaCTPN'],
        ),
      );
    }

    return cuonSachs;
  }

  Future<List<CuonSachDto2th>> queryCuonSachDto2thSanCoWithKeyword(
      String keyword) async {
    /* 
    Truy vấn các cuốn sách có MaCuonSach hoặc TenDauSach chứa keyword
    và tình trạng là có sẵn
    */
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCuonSach, MaDauSach, MaSach, TenDauSach, LanTaiBan, NhaXuatBan, ViTri
      from DauSach join Sach using(MaDauSach) 
      join CT_PhieuNhap using(MaSach)
      join CuonSach using(MaSach, MaCTPN)
      where (TenDauSach like ? or MaCuonSach like ?) and CuonSach.TinhTrang = 'Có sẵn'
      ''',
      [
        '%${keyword.toLowerCase()}%',
        '%${keyword.toLowerCase()}%',
      ],
    );

    List<CuonSachDto2th> cuonSachs = [];

    for (var element in data) {
      final cuonSach = CuonSachDto2th(
        element['MaCuonSach'],
        element['MaSach'],
        element['TenDauSach'],
        element['LanTaiBan'],
        element['NhaXuatBan'],
        element['ViTri'],
        [],
      );

      final tacGiasData = await _database.rawQuery(
        '''
        select TenTacGia 
        from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
        [
          element['MaDauSach'],
        ],
      );

      for (var tacGia in tacGiasData) {
        cuonSach.tacGias.add(
          tacGia['TenTacGia'] as String,
        );
      }

      cuonSachs.add(cuonSach);
    }

    return cuonSachs;
  }

  Future<CuonSachDto2th?> queryCuonSachDto2thSanCoWithMaCuonSach(
      String maCuonSach) async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCuonSach, MaDauSach, MaSach, TenDauSach, LanTaiBan, NhaXuatBan
      from DauSach join Sach using(MaDauSach) 
      join CT_PhieuNhap using(MaSach)
      join CuonSach using(MaSach, MaCTPN)
      where MaCuonSach = ? and CuonSach.TinhTrang = 'Có sẵn'
      ''',
      [maCuonSach],
    );

    if (data.isEmpty) {
      return null;
    }

    final element = data.first;

    final cuonSach = CuonSachDto2th(
      element['MaCuonSach'],
      element['MaSach'],
      element['TenDauSach'],
      element['LanTaiBan'],
      element['NhaXuatBan'],
      '',
      [],
    );

    final tacGiasData = await _database.rawQuery(
      '''
        select TenTacGia 
        from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
      [
        element['MaDauSach'],
      ],
    );

    for (var tacGia in tacGiasData) {
      cuonSach.tacGias.add(
        tacGia['TenTacGia'] as String,
      );
    }

    return cuonSach;
  }

  Future<void> updateViTriCuonSach(String viTri, String maCuonSach) async {
    await _database.rawUpdate(
      '''
      update CuonSach
      set ViTri = ?
      where MaCuonSach = ?
      ''',
      [
        viTri,
        maCuonSach,
      ],
    );
  }

  Future<void> updateTinhTrangCuonSachWithMaCuonSach(
      String maCuonSach, String tinhTrang) async {
    await _database.rawUpdate(
      '''
      update CuonSach
      set TinhTrang = ?
      where MaCuonSach = ?
      ''',
      [
        tinhTrang,
        maCuonSach,
      ],
    );
  }

  Future<Map<String, dynamic>> queryThongTinChiTietPhieuNhapCuonSach(
      int maCTPN) async {
    final data = await _database.rawQuery(
      '''
      select MaPhieuNhap, NgayLap, SoLuong, DonGia
      from PhieuNhap
      join CT_PhieuNhap using(MaPhieuNhap)
      where MaCTPN = ?
      ''',
      [maCTPN],
    );
    return data.first;
  }

  /* PHIẾU MƯỢN CODE */
  Future<void> insertPhieuMuon(PhieuMuon phieuMuon) async {
//     print('''
// INSERT INTO PhieuMuon(MaPhieuMuon, MaCuonSach, MaDocGia, NgayMuon, HanTra, TinhTrang)
// VALUES ('${phieuMuon.maCuonSach}', '${phieuMuon.maDocGia}', '${phieuMuon.ngayMuon.toVnFormat()}', '${phieuMuon.hanTra.toVnFormat()}', 'Đang mượn');
// ''');
    await _database.insert(
      'PhieuMuon',
      phieuMuon.toMap(),
    );
  }

  Future<int> querySoSachDangMuonCuaDocGia(int maDocGia) async {
    final List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select count(MaPhieuMuon) as count from PhieuMuon
      where TinhTrang = 'Đang mượn' and MaDocGia = ?
      ''',
      [maDocGia],
    );

    return data.first['count'];
  }

  Future<int> querySoSachMuonQuahanCuaDocGia(int maDocGia) async {
    final List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select HanTra from PhieuMuon
      where TinhTrang = 'Đang mượn' and MaDocGia = ?
      ''',
      [maDocGia],
    );

    int count = 0;
    for (var element in data) {
      if (vnDateFormat
          .parse(element['HanTra'])
          .endOfDay()
          .isBefore(DateTime.now())) {
        count++;
      }
    }

    return count;
  }

  Future<List<PhieuMuonCanTraDto>> queryPhieuMuonCanTraDtoWithMaDocGia(
      int maDocGia) async {
    final List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaPhieuMuon, MaCuonSach, MaDauSach, TenDauSach, LanTaiBan, NhaXuatBan, NgayMuon, HanTra
      from PhieuMuon join CuonSach using(MaCuonSach) 
      join Sach using(MaSach)
      join DauSach using(MaDauSach)
      where MaDocGia = ? and PhieuMuon.TinhTrang = 'Đang mượn'
      ''',
      [maDocGia],
    );

    List<PhieuMuonCanTraDto> phieuMuons = [];

    for (var element in data) {
      final phieuMuon = PhieuMuonCanTraDto(
        element['MaPhieuMuon'],
        element['MaCuonSach'],
        element['TenDauSach'],
        element['LanTaiBan'],
        element['NhaXuatBan'],
        vnDateFormat.parse(element['NgayMuon']),
        vnDateFormat.parse(element['HanTra']),
        [],
      );

      final tacGiasData = await _database.rawQuery(
        '''
        select TenTacGia 
        from TacGia_DauSach join TacGia USING(MaTacGia)
        where MaDauSach = ?
        ''',
        [
          element['MaDauSach'],
        ],
      );

      for (var tacGia in tacGiasData) {
        phieuMuon.tacGias.add(
          tacGia['TenTacGia'] as String,
        );
      }

      phieuMuons.add(phieuMuon);
    }

    return phieuMuons;
  }

  Future<void> updateTinhTrangPhieuMuonWithMaPhieuMuon(
      int maPhieuMuon, String tinhTrang) async {
    await _database.rawUpdate(
      '''
      update PhieuMuon
      set TinhTrang = ?
      where MaPhieuMuon = ?
      ''',
      [
        tinhTrang,
        maPhieuMuon,
      ],
    );
  }

  Future<List<PhieuMuonDto>> queryPhieuMuonDtoWithMaDocGia(int maDocGia) async {
    final List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaPhieuMuon, MaCuonSach, TenDauSach, NgayMuon, HanTra, PhieuMuon.TinhTrang 
      from PhieuMuon join CuonSach using(MaCuonSach) 
      join Sach using(MaSach)
      join DauSach using(MaDauSach)
      where MaDocGia = ?
      ''',
      [maDocGia],
    );

    List<PhieuMuonDto> phieuMuons = [];

    for (var element in data) {
      final phieuMuon = PhieuMuonDto(
        element['MaPhieuMuon'],
        element['MaCuonSach'],
        element['TenDauSach'],
        vnDateFormat.parse(element['NgayMuon']),
        vnDateFormat.parse(element['HanTra']),
        element['TinhTrang'],
      );

      if (phieuMuon.tinhTrang == 'Đang mượn' &&
          phieuMuon.hanTra.endOfDay().isBefore(DateTime.now())) {
        phieuMuon.tinhTrang = 'Quá hạn';
      }

      phieuMuons.add(
        phieuMuon,
      );
    }

    return phieuMuons;
  }

  /* PHIẾU TRẢ CODE */
  Future<void> insertPhieuTra(PhieuTra phieuTra) async {
    await _database.insert(
      'PhieuTra',
      phieuTra.toMap(),
    );
  }

  Future<List<PhieuTra>> queryPhieuTraWithMaDocGia(int maDocGia) async {
    final List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaPhieuTra, MaPhieuMuon, NgayTra, SoTienPhat
      from PhieuTra join PhieuMuon using(MaPhieuMuon)
      where MaDocGia = ?
      ''',
      [maDocGia],
    );

    List<PhieuTra> phieuTras = [];

    for (var element in data) {
      phieuTras.add(
        PhieuTra(
          element['MaPhieuTra'],
          element['MaPhieuMuon'],
          vnDateFormat.parse(element['NgayTra']),
          element['SoTienPhat'],
        ),
      );
    }

    return phieuTras;
  }

  /* REPORT CODE */

  // REPORT DOCGIA THEO THANG
  Future<List<TKDocGia>> queryDocGiaTheoThang() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaDocGia, NgayLapThe, HoTen
      from DocGia 

      ''',
    );

    List<TKDocGia> danhSachDocGia = [];

    for (var element in data) {
      DateTime createCardDate =
          vnDateFormat.parse(element['NgayLapThe'] as String);
      danhSachDocGia.add(
        TKDocGia(
          createCardDate.day,
          createCardDate.month,
          createCardDate.year,
          element['HoTen'],
          element['MaDocGia'],
        ),
      );
    }
    return danhSachDocGia;
  }

  // REPORT CUON SACH DA MUON THEO THANG
  Future<List<TKSach>> querySachMuonTheoThang() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaCuonSach, NgayMuon, TenDauSach
      from PhieuMuon join CuonSach USING(MaCuonSach) 
      join Sach using(MaSach)
      join DauSach using(MaDauSach)

      ''',
    );
    List<TKSach> danhSachSachMuon = [];
    for (var element in data) {
      DateTime date = vnDateFormat.parse(element['NgayMuon'] as String);
      danhSachSachMuon.add(
        TKSach(date.day, date.month, date.year, element['MaCuonSach'],
            element['TenDauSach']),
      );
    }
    return danhSachSachMuon;
  }

  // REPORT THE LOAI SACH MUON
  Future<List<TKTheLoai>> queryTheLoaiSachMuonTheoNam() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select NgayMuon, TenTheLoai, count(MaCuonSach) as quanity
      from PhieuMuon join CuonSach USING(MaCuonSach) 
      join Sach using(MaSach)
      join DauSach_TheLoai using(MaDauSach)
      join TheLoai using(MaTheLoai)
      group by MaTheLoai
      ''',
    );
    List<TKTheLoai> danhSachTheLoaiSachMuon = [];
    for (var element in data) {
      DateTime date = vnDateFormat.parse(element['NgayMuon'] as String);
      danhSachTheLoaiSachMuon.add(
        TKTheLoai(date.year, element['TenTheLoai'], element['quanity']),
      );
    }
    return danhSachTheLoaiSachMuon;
  }

  // REPORT SACH NHAP
  Future<List<TKSach>> querySachNhapTheoThang() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select MaSach, NgayLap, TenDauSach 
      from PhieuNhap join CT_PhieuNhap USING(MaPhieuNhap)
      join Sach using(MaSach) 
      join DauSach using(MaDauSach)

      ''',
    );
    List<TKSach> danhSachSachMuon = [];
    for (var element in data) {
      DateTime date = vnDateFormat.parse(element['NgayLap'] as String);
      danhSachSachMuon.add(
        TKSach(date.day, date.month, date.year, element['MaSach'].toString(),
            element['TenDauSach']),
      );
    }
    return danhSachSachMuon;
  }

  // REPORT DOANH THU
  // REPORT TIEN PHAT
  Future<List<TKThuNhap>> queryTienPhatTheoThang() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select NgayTra, HoTen, SoTienPhat
      from PhieuTra join PhieuMuon USING(MaPhieuMuon)
      join DocGia USING(MaDocGia)

      ''',
    );
    List<TKThuNhap> danhSachTienPhat = [];
    for (var element in data) {
      DateTime date = vnDateFormat.parse(element['NgayTra'] as String);
      danhSachTienPhat.add(
        TKThuNhap(date.day, date.month, date.year, element['HoTen'].toString(),
            "fine", element['SoTienPhat']),
      );
    }
    return danhSachTienPhat;
  }

  // REPORT TIEN TAO THE
  Future<List<TKThuNhap>> queryTienTaoTheTheoThang() async {
    List<Map<String, dynamic>> data = await _database.rawQuery(
      '''
      select HoTen, PhiTaoThe, NgayTao
      from CT_TaoThe join DocGia USING(MaDocGia)

      ''',
    );
    List<TKThuNhap> danhSachTienTao = [];
    for (var element in data) {
      DateTime date = vnDateFormat.parse(element['NgayTao'] as String);
      danhSachTienTao.add(
        TKThuNhap(date.day, date.month, date.year, element['HoTen'].toString(),
            "fee", element['PhiTaoThe']),
      );
    }
    return danhSachTienTao;
  }
}
