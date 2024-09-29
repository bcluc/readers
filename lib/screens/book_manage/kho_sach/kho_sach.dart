import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/my_search_bar.dart';
import 'package:readers/main.dart';
import 'package:readers/models/lich_su_tim_kiem.dart';
import 'package:readers/screens/book_manage/kho_sach/ket_qua_tim_kiem.dart';

class KhoSach extends StatefulWidget {
  const KhoSach({super.key});

  @override
  State<KhoSach> createState() => _KhoSachState();
}

class _KhoSachState extends State<KhoSach> {
  final _searchController = TextEditingController();

  late List<LichSuTimKiem> _lichSuTimKiemCuonSachs;

  late final Future<void> _futureLichSuTimKiemCuonSachs =
      _getLichSuTimKiemCuonSachs();
  Future<void> _getLichSuTimKiemCuonSachs() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _lichSuTimKiemCuonSachs =
        await dbProcess.queryLichSuTimKiem(loaiTimKiem: 'CuonSach');
  }

  void updateTuKhoaTimKiemGanDay(int index) {
    /* Cập nhật lại thời gian tìm kiếm cho LichSuTimKiemCuonSach này */
    _lichSuTimKiemCuonSachs[index].searchTimestamp =
        DateTime.now().millisecondsSinceEpoch;

    /* Update DB */
    dbProcess
        .updateSearchTimestampLichSuTimKiem(_lichSuTimKiemCuonSachs[index]);

    /* Cho Từ khóa vừa Click lên đầu mảng */
    final element = _lichSuTimKiemCuonSachs.removeAt(index);
    _lichSuTimKiemCuonSachs.insert(0, element);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MySearchBar(
            controller: _searchController,
            onSearch: (value) {
              /* 
              Phòng trường hợp gõ tiếng việt
              VD: o -> (rỗng) -> ỏ
              Lúc này, value sẽ bằng '' (rỗng) nhưng _searchController.text lại bằng "ỏ"
              */
              if (_searchController.text == value) {
                setState(() {});
                String searchText = _searchController.text.toLowerCase();
                if (searchText.isEmpty) {
                  return;
                }
                int index = _lichSuTimKiemCuonSachs
                    .indexWhere((element) => element.tuKhoa == searchText);
                // print('index = $index');
                if (index == -1) {
                  /* 
                  Từ khóa không khớp với những từ khóa hiện tại
                  => Thêm mới từ khóa tìm kiếm gần đây 
                  */
                  final newLichSuTimKiem = LichSuTimKiem(
                    DateTime.now().millisecondsSinceEpoch,
                    'CuonSach',
                    searchText,
                  );

                  _lichSuTimKiemCuonSachs.insert(0, newLichSuTimKiem);
                  dbProcess.insertLichSuTimKiem(newLichSuTimKiem);

                  /* Giới hạn chỉ lưu 12 từ khóa tìm kiếm gần đây */
                  if (_lichSuTimKiemCuonSachs.length > 12) {
                    /* Nếu quá 12 từ, tức là đang 13 từ khóa thì xóa từ khóa có timestamp nhỏ nhất */
                    int minTimestampIndex = 0;
                    for (int i = 1; i < _lichSuTimKiemCuonSachs.length; ++i) {
                      if (_lichSuTimKiemCuonSachs[i].searchTimestamp <
                          _lichSuTimKiemCuonSachs[minTimestampIndex]
                              .searchTimestamp) {
                        minTimestampIndex = i;
                      }
                    }
                    // print(_lichSuTimKiemCuonSachs[minTimestampIndex].tuKhoa);
                    dbProcess.deleteLichSuTimKiem(
                        _lichSuTimKiemCuonSachs[minTimestampIndex]);
                    _lichSuTimKiemCuonSachs.removeAt(minTimestampIndex);
                  }
                } else {
                  updateTuKhoaTimKiemGanDay(index);
                }
              }
            },
          ),
          const Gap(20),
          Text(
            _searchController.text.isEmpty
                ? 'Danh sách Tìm kiếm gần đây'
                : 'Danh sách kết quả',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(8),
          FutureBuilder(
            future: _futureLichSuTimKiemCuonSachs,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (_lichSuTimKiemCuonSachs.isEmpty) {
                return const Text(
                  'Chưa có dữ liệu',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                );
              }

              return _searchController.text.isEmpty
                  ? Expanded(
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 380,
                          mainAxisExtent: 54,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        children: List.generate(
                          _lichSuTimKiemCuonSachs.length,
                          (index) {
                            bool isHover = false;
                            return Ink(
                              /* 
                            Thêm key ở đây để khi xóa hàng loạt các Từ khóa Tìm kiếm Gần đây sẽ không gặp lỗi 
                            (lỗi này không gây ra crash hệ thống)
                            Thử comment dòng "key: ValueKey(...)" để thấy.
                            */
                              key: ValueKey(_lichSuTimKiemCuonSachs[index]),
                              color: Colors.grey.withOpacity(0.1),
                              child: StatefulBuilder(
                                builder: (ctx, setStateInkWell) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _searchController.text =
                                            _lichSuTimKiemCuonSachs[index]
                                                .tuKhoa;
                                      });

                                      updateTuKhoaTimKiemGanDay(index);
                                    },
                                    onHover: (value) =>
                                        setStateInkWell(() => isHover = value),
                                    hoverColor: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.9),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                            _lichSuTimKiemCuonSachs[index]
                                                .tuKhoa,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isHover
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          const Spacer(),
                                          /* Nút Xóa lịch sử tìm kiếm Cuốn Sách */
                                          if (isHover)
                                            IconButton(
                                              onPressed: () {
                                                dbProcess.deleteLichSuTimKiem(
                                                    _lichSuTimKiemCuonSachs[
                                                        index]);
                                                setState(() {
                                                  _lichSuTimKiemCuonSachs
                                                      .removeAt(index);
                                                });
                                              },
                                              icon: const Icon(Icons.close,
                                                  color: Colors.white),
                                              style: IconButton.styleFrom(
                                                foregroundColor: Colors.white,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Expanded(
                      child: KetQuaTimKiem(
                        keyword: _searchController.text,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
