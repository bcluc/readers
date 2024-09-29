import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/dto/phieu_muon_can_tra_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/borrow_return/tra_sach/phieu_tra_section.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

class TraSach extends StatefulWidget {
  const TraSach({super.key});

  @override
  State<TraSach> createState() => TraSachState();
}

class TraSachState extends State<TraSach> {
  final _searchMaDocGiaController = TextEditingController();

  final ngayTraController = TextEditingController(
    text: DateTime.now().toVnFormat(),
  );

  String _errorText = '';
  String _maDocGia = '';
  String _hoTenDocGia = '';

  bool _isProcessingMaDocGia = false;

  int _selectedPhieuMuon = -1;

  List<PhieuMuonCanTraDto> _phieuMuons = [];

  Future<void> _searchMaDocGia() async {
    _errorText = '';
    if (_searchMaDocGiaController.text.isEmpty) {
      _errorText = 'Bạn chưa nhập Mã Độc giả.';
    } else {
      if (int.tryParse(_searchMaDocGiaController.text) == null) {
        _errorText = 'Mã Độc giả là một con số.';
      }
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessingMaDocGia = true;
    });

    _hoTenDocGia = '';
    _maDocGia = '';

    int maDocGia = int.parse(_searchMaDocGiaController.text);

    String? hoTen = await dbProcess.queryHoTenDocGiaWithMaDocGia(maDocGia);
    await Future.delayed(const Duration(milliseconds: 200));

    if (hoTen == null) {
      _errorText = 'Không tìm thấy Độc giả.';
    } else {
      _maDocGia = maDocGia.toString();
      _hoTenDocGia = hoTen.capitalizeFirstLetterOfEachWord();
      _phieuMuons = await dbProcess
          .queryPhieuMuonCanTraDtoWithMaDocGia(int.parse(_maDocGia));

      _selectedPhieuMuon = -1;
    }

    setState(() {
      _isProcessingMaDocGia = false;
    });
  }

  @override
  void dispose() {
    _searchMaDocGiaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tìm Độc giả',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchMaDocGiaController,
                            autofocus: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 245, 246, 250),
                              hintText: 'Nhập Mã độc giả',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(14),
                              isCollapsed: true,
                              errorMaxLines: 2,
                            ),
                            onEditingComplete: _searchMaDocGia,
                          ),
                        ),
                        const Gap(10),
                        _isProcessingMaDocGia
                            ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                height: 44,
                                width: 44,
                                padding: const EdgeInsets.all(12),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton.filled(
                                onPressed: _searchMaDocGia,
                                icon: const Icon(Icons.arrow_forward_rounded),
                                style: myIconButtonStyle,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(50),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mã Độc giả:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 44,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _maDocGia.isEmpty
                            ? const Color(0xffEFEFEF)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _maDocGia,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(50),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Họ tên:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 44,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _hoTenDocGia.isEmpty
                            ? const Color(0xffEFEFEF)
                            : Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _hoTenDocGia,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          const Text(
            'DANH SÁCH PHIẾU MƯỢN CẦN TRẢ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(4),
          _isProcessingMaDocGia
              ? const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _maDocGia.isEmpty
                  ? Text(
                      _errorText.isEmpty
                          ? 'Bạn cần nhập Mã Độc giả để hiển thị danh sách'
                          : _errorText,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: _errorText.isEmpty
                            ? null
                            : Theme.of(context).colorScheme.error,
                      ),
                    )
                  : _phieuMuons.isEmpty
                      ? Text(
                          'Độc giả $_hoTenDocGia chưa mượn cuốn sách nào.',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        )
                      : Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: EdgeInsets.only(
                                              left: 20, right: 15),
                                          child: Text(
                                            'Mã PM',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
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
                                        flex: 6,
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
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            'Lần tái bản',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
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
                                        flex: 5,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            'Tác giả',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text(
                                            'Ngày mượn',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 20),
                                          child: Text(
                                            'Hạn trả',
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
                                ...List.generate(
                                  _phieuMuons.length,
                                  (index) {
                                    bool isMaPhieuMuonHover = false;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: StatefulBuilder(builder:
                                                  (ctx, setStateMaPhieuMuon) {
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedPhieuMuon =
                                                          index;
                                                    });
                                                  },
                                                  onHover: (value) =>
                                                      setStateMaPhieuMuon(
                                                    () => isMaPhieuMuonHover =
                                                        value,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        20, 15, 15, 15),
                                                    child: SizedBox(
                                                      height: 24,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            isMaPhieuMuonHover
                                                                ? 'Trả'
                                                                : _phieuMuons[
                                                                        index]
                                                                    .maPhieuMuon
                                                                    .toString(),
                                                          ),
                                                          const Gap(6),
                                                          if (isMaPhieuMuonHover)
                                                            const Icon(Icons
                                                                .arrow_downward_rounded),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Text(
                                                  _phieuMuons[index].maCuonSach,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 6,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        _phieuMuons[index]
                                                            .tenDauSach
                                                            .capitalizeFirstLetterOfEachWord(),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Text(
                                                  _phieuMuons[index]
                                                      .lanTaiBan
                                                      .toString(),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Text(
                                                  _phieuMuons[index].nhaXuatBan,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Text(
                                                  _phieuMuons[index]
                                                      .tacGiasToString(),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                child: Text(
                                                  _phieuMuons[index]
                                                      .ngayMuon
                                                      .toVnFormat(),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 20),
                                                child: Text(
                                                  _phieuMuons[index]
                                                      .hanTra
                                                      .toVnFormat(),
                                                  style: _phieuMuons[index]
                                                          .hanTra
                                                          .endOfDay()
                                                          .isBefore(
                                                              DateTime.now())
                                                      ? const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Color(0xFFD80032),
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          height: 0,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const Spacer(),
                                PhieuTraSection(
                                  maPhieuMuon: _selectedPhieuMuon == -1
                                      ? null
                                      : _phieuMuons[_selectedPhieuMuon]
                                          .maPhieuMuon,
                                  maCuonSach: _selectedPhieuMuon == -1
                                      ? null
                                      : _phieuMuons[_selectedPhieuMuon]
                                          .maCuonSach,
                                  hanTra: _selectedPhieuMuon == -1
                                      ? null
                                      : _phieuMuons[_selectedPhieuMuon].hanTra,
                                  onTraPhieu: () => setState(() {
                                    /* Xóa phiếu mượn và Update UI */
                                    _phieuMuons.removeAt(_selectedPhieuMuon);
                                    _selectedPhieuMuon = -1;
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
        ],
      ),
    );
  }
}
