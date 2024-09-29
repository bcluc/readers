import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/models/report_doc_gia.dart';
import 'package:readers/utils/extension.dart';

class BaoCaoChiTietDocGia extends StatelessWidget {
  const BaoCaoChiTietDocGia({required this.list, super.key});

  final List<TKDocGia> list;

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
                      'Không có độc giả nào được đăng ký',
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
                      const Text(
                        'Các độc giả được thêm vào',
                        style: TextStyle(
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
                  const Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'Mã độc giả',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Tên độc giả',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Ngày lập thẻ',
                          style: TextStyle(
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 15, 15),
                                        child: Text(
                                          list[index].maDocGia.toString(),
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
                                              .hoTen
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
