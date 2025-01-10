import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/regulations/regulation_item.dart';
import 'package:readers/utils/parameters.dart';

class Regulations extends StatefulWidget {
  const Regulations({super.key});

  @override
  State<Regulations> createState() => _RegulationsState();
}

class _RegulationsState extends State<Regulations> {
  final _formKey = GlobalKey<FormState>();

  Future<void> getThamSo() async {
    await Future.delayed(kTabScrollDuration);
    ThamSoQuyDinh.thietLapThamSo(await dbProcess.queryThamSoQuyDinh());
  }

  @override
  void initState() {
    _tenThuVienController.text = ThamSoQuyDinh.tenThuVien;
    _soDienThoaiController.text = ThamSoQuyDinh.soDienThoai;
    _emailController.text = ThamSoQuyDinh.email;
    _diaChiController.text = ThamSoQuyDinh.diaChi;
    super.initState();
  }

  final _tenThuVienController = TextEditingController();

  final _soDienThoaiController = TextEditingController();

  final _emailController = TextEditingController();

  final _diaChiController = TextEditingController();

  void _updateThamSo(String tenThamSo, String giaTri) async {
    /* Cập nhật trong database */
    await dbProcess.updateGiaTriThamSo(
      thamSo: tenThamSo,
      giaTri: giaTri,
    );
    setState(() {});
  }

  Future<void> _saveThongTin(BuildContext context) async {
    bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _updateThamSo('TenThuVien', _tenThuVienController.text);
    _updateThamSo('SoDienThoai', _soDienThoaiController.text);
    _updateThamSo('Email', _emailController.text);
    _updateThamSo('DiaChi', _diaChiController.text);

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).clearSnackBars();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cập nhật Thông tin thành công.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
        width: 300,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getThamSo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _tenThuVienController.text = ThamSoQuyDinh.tenThuVien;
            _soDienThoaiController.text = ThamSoQuyDinh.soDienThoai;
            _emailController.text = ThamSoQuyDinh.email;
            _diaChiController.text = ThamSoQuyDinh.diaChi;
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30, 24, 30, 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thông tin',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tên thư viện:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(4),
                                      TextFormField(
                                        controller: _tenThuVienController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          isCollapsed: true,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bạn chưa nhập Tên thư viện';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(30),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Số điện thoại:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(4),
                                      TextFormField(
                                        controller: _soDienThoaiController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          isCollapsed: true,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bạn chưa nhập Số điện thoại';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(30),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email:',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(4),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.all(14),
                                          isCollapsed: true,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bạn chưa nhập Email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const Gap(10),
                            const Text(
                              'Địa chỉ:',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(4),
                            TextFormField(
                              controller: _diaChiController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                                isCollapsed: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Bạn chưa nhập Địa chỉ';
                                }
                                return null;
                              },
                            ),
                            const Gap(20),
                            Align(
                              alignment: Alignment.center,
                              child: FilledButton(
                                onPressed: () => _saveThongTin(context),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 30,
                                  ),
                                ),
                                child: const Text(
                                  'Lưu Thông tin',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(18),
                  const Text(
                    'Tham số',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const RegulationItem(
                      content: '1. Số ngày mượn tối đa của một cuốn sách: ',
                      regulation: 'SoNgayMuonToiDa'),
                  const RegulationItem(
                      content: '2. Số sách được mượn tối đa của một độc giả: ',
                      regulation: 'SoSachMuonToiDa'),
                  const RegulationItem(
                      content:
                          '3. Mức tiền phạt cho mỗi cuốn sách mượn quá hạn: ',
                      regulation: 'MucThuTienPhat'),
                  const RegulationItem(
                      content: '4. Số tuổi tối thiểu của được phép mượn sách:',
                      regulation: 'TuoiToiThieu'),
                  const RegulationItem(
                      content: '5. Phí tạo thẻ cho độc giả: ',
                      regulation: 'PhiTaoThe'),
                  const RegulationItem(
                      content: '6. Thời gian hiệu lực của thẻ độc giả: ',
                      regulation: 'ThoiHanThe'),
                ],
              ),
            ),
          );
        });
  }
}
