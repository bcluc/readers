import 'package:flutter/material.dart';
import 'package:readers/features/sach_management/dtos/cuon_sach_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/book_manage/kho_sach/edit_vi_tri_cuon_sach_form.dart';
import 'package:readers/screens/book_manage/kho_sach/xem_chi_tiet_phieu_nhap_form.dart';
import 'package:readers/utils/extension.dart';

class KetQuaTimKiem extends StatefulWidget {
  const KetQuaTimKiem({
    super.key,
    required this.keyword,
  });

  final String keyword;

  @override
  State<KetQuaTimKiem> createState() => _KetQuaTimKiemState();
}

class _KetQuaTimKiemState extends State<KetQuaTimKiem> {
  late List<CuonSachDto> _cuonSachs;

  // int _selectedRow = -1;

  Future<void> _getCuonSachs() async {
    /* 
    Delay 1 khoảng bằng thời gian
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(const Duration(milliseconds: 300));
    _cuonSachs = await dbProcess.queryCuonSachDtoWithKeyword(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        // Gọi hàm lấy dữ liệu từ DB mỗi khi build
        future: _getCuonSachs(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (_cuonSachs.isEmpty) {
            return Text(
              'Không tìm thấy cuốn sách khớp với từ khóa "${widget.keyword}"',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30, right: 15),
                          child: Text(
                            'Mã CS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Tên Đầu sách',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Lần Tái Bản',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'NXB',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Tình trạng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 280,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'Vị trí',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15, right: 30),
                          child: Text(
                            'Mã CTPN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 15),
                                  child: Text(
                                    _cuonSachs[index].maCuonSach,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    _cuonSachs[index]
                                        .tenDauSach
                                        .capitalizeFirstLetter(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    _cuonSachs[index].lanTaiBan.toString(),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    _cuonSachs[index].nhaXuatBan,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: 15,
                                    ),
                                    child: Text(
                                      _cuonSachs[index].tinhTrang,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 280,
                                child: StatefulBuilder(
                                    builder: (ctx, setStateViTriInkWell) {
                                  return InkWell(
                                    onTap: () async {
                                      String? updatedViTri = await showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              EditViTriCuonSachForm(
                                                  viTri:
                                                      _cuonSachs[index].viTri));

                                      if (updatedViTri != null) {
                                        setStateViTriInkWell(
                                          () => _cuonSachs[index].viTri =
                                              updatedViTri,
                                        );

                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .clearSnackBars();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Cập nhật Vị trí cuốn sách thành công.',
                                                textAlign: TextAlign.center,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              width: 400,
                                            ),
                                          );
                                        }

                                        dbProcess.updateViTriCuonSach(
                                            _cuonSachs[index].viTri,
                                            _cuonSachs[index].maCuonSach);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 15,
                                      ),
                                      child: Text(
                                        _cuonSachs[index].viTri,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(
                                width: 120,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => XemChiTietPhieuNhap(
                                        maCTPN: _cuonSachs[index].maCTPN,
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 15,
                                        right: 30),
                                    child: Text(
                                      _cuonSachs[index].maCTPN.toString(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (index < _cuonSachs.length - 1)
                            const Divider(
                              height: 0,
                            ),
                        ],
                      );
                    },
                    itemCount: _cuonSachs.length,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
