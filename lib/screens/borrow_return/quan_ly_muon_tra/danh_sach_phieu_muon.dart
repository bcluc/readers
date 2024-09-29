import 'package:flutter/material.dart';
import 'package:readers/dto/phieu_muon_dto.dart';
import 'package:readers/utils/extension.dart';

class DanhSachPhieuMuon extends StatelessWidget {
  const DanhSachPhieuMuon({super.key, required this.phieuMuons});

  final List<PhieuMuonDto> phieuMuons;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                  width: 140,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 15),
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
                  flex: 5,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
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
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 30),
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
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: List.generate(
                phieuMuons.length,
                (index) {
                  final tinhTrangColor = switch (phieuMuons[index].tinhTrang) {
                    'Đã trả' => const Color(0xFF9ADE7B),
                    'Đang mượn' =>
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    'Quá hạn' => const Color(0xFFD80032),
                    String() => null,
                  };
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 140,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 15, 15, 15),
                              child: Text(
                                phieuMuons[index].maPhieuMuon.toString(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                phieuMuons[index].maCuonSach,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                phieuMuons[index]
                                    .tenDauSach
                                    .capitalizeFirstLetterOfEachWord(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                phieuMuons[index].ngayMuon.toVnFormat(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Text(
                                phieuMuons[index].hanTra.toVnFormat(),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: tinhTrangColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  phieuMuons[index].tinhTrang,
                                ),
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
            ),
          )
        ],
      ),
    );
  }
}
