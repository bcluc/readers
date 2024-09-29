import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/models/report_sach.dart';
import 'package:readers/utils/extension.dart';

class BaoCaoSachChiTiet extends StatelessWidget {
  const BaoCaoSachChiTiet(
      {required this.barIndex, required this.list, super.key});
  final List<TKSach> list;
  final int barIndex;
  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
              width: 500,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Không có cuốn sách nào được ghi nhận',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
              )));
    } else {
      return Dialog(
          backgroundColor: Colors.white,
          child: SizedBox(
            width: 500,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        (barIndex == 0)
                            ? 'Danh sách các cuốn sách được mượn'
                            : 'Danh sách các cuốn sách được nhập',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      )
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Text(
                          'Mã sách',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Expanded(
                        flex: 3,
                        child: Text(
                          'Tên sách',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 2,
                        child: Text(
                          (barIndex == 0) ? 'Ngày mượn sách' : 'Ngày nhập sách',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        list.length,
                        (index) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 15, 15),
                                        child: Text(
                                          list[index].maCuonSach.toString(),
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
                                          list[index]
                                              .tenSach
                                              .capitalizeFirstLetterOfEachWord(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                        ),
                                        child: Text(
                                          '${list[index].day} / ${list[index].month} / ${list[index].year}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 0,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }
  }
}
