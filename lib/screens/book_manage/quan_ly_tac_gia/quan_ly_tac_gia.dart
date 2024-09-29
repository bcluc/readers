import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/my_search_bar.dart';
import 'package:readers/dto/tac_gia_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/models/tac_gia.dart';
import 'package:readers/screens/book_manage/quan_ly_tac_gia/edit_ten_tac_gia.dart';
import 'package:readers/screens/book_manage/quan_ly_tac_gia/tat_ca_sach_cua_tac_gia.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

class QuanLyTacGia extends StatefulWidget {
  const QuanLyTacGia({super.key});

  @override
  State<QuanLyTacGia> createState() => _QuanLyTacGiaState();
}

class _QuanLyTacGiaState extends State<QuanLyTacGia> {
  /* _tacGias lưu chứa những tác giả ở dạng chữ in thường */
  late final List<TacGiaDto> _tacGias;
  late List<TacGiaDto> _filteredTacGias;

  int _selectedRow = -1;

  final _searchController = TextEditingController();
  final _themTacGiaController = TextEditingController();

  late final Future<void> _futureTacGias = _getTacGias();
  Future<void> _getTacGias() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _tacGias = await dbProcess.queryTacGiaDtos();
  }

  void _addTacGia() async {
    final tenTacGia = _themTacGiaController.text.trim();
    if (tenTacGia.isEmpty) {
      return;
    }

    final tenTacGiaInThuong = tenTacGia.toLowerCase();

    /* Kiểm tra tenTacGia được nhập đã tồn tại chưa */
    for (var tacGia in _tacGias) {
      if (tacGia.tenTacGia == tenTacGiaInThuong) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(
                  'Tác giả ${tacGia.tenTacGia.capitalizeFirstLetterOfEachWord()} đã tồn tại.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'Mã tác giả: ${tacGia.maTacGia}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 400,
          ),
        );
        return;
      }
    }

    final returningId = await dbProcess.insertTacGia(
      TacGia(null, tenTacGiaInThuong),
    );

    _themTacGiaController.clear();

    setState(() {
      _tacGias.add(
        TacGiaDto(returningId, tenTacGiaInThuong, 0),
      );
    });

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thêm tác giả thành công',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 300,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureTacGias,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        String searchText = _searchController.text.toLowerCase();
        if (searchText.isEmpty) {
          _filteredTacGias = List.of(_tacGias);
        } else {
          _filteredTacGias = _tacGias.where((element) {
            if (element.maTacGia.toString().contains(searchText) ||
                element.tenTacGia.toLowerCase().contains(searchText)) {
              return true;
            }
            return false;
          }).toList();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 25),
          child: Column(
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
                  }
                },
              ),
              const Gap(20),
              Row(
                children: [
                  const Text(
                    'Danh sách Tác giả',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _themTacGiaController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 245, 246, 250),
                        hintText: 'Tên tác giả',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 81, 81, 81),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 20, 16, 12),
                      ),
                      onEditingComplete: _addTacGia,
                    ),
                  ),
                  const Gap(12),
                  FilledButton.icon(
                    onPressed: _addTacGia,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm Tác giả'),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                    ),
                  ),
                  const Gap(12),
                  IconButton.filled(
                    onPressed: (_selectedRow == -1)
                        ? null
                        : () async {
                            final readyDeleteTacGia =
                                _filteredTacGias[_selectedRow];
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Xác nhận'),
                                content: Text(
                                    'Bạn có chắc xóa Tác giả ${readyDeleteTacGia.tenTacGia.capitalizeFirstLetterOfEachWord()}?'),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Huỷ'),
                                  ),
                                  FilledButton(
                                    onPressed: () {
                                      dbProcess.deleteTacGiaWithMaTacGia(
                                          readyDeleteTacGia.maTacGia);

                                      setState(() {
                                        _tacGias.removeWhere((element) =>
                                            element.maTacGia ==
                                            readyDeleteTacGia.maTacGia);
                                        _filteredTacGias.removeAt(_selectedRow);
                                        /*
                                        Phòng trường hợp khi _selectedRow đang ở cuối bảng và ta nhấn xóa dòng cuối của bảng
                                        Lúc này _selectedRow đã nằm ngoài mảng, và nút "Xóa" vẫn chưa được Disable
                                        => Có khả năng gây ra lỗi
                                        Solution: Sau khi xóa phải kiểm tra lại
                                        xem _selectedRow có nằm ngoài phạm vi của _filteredTacGias hay không.
                                        */
                                        if (_selectedRow >=
                                            _filteredTacGias.length) {
                                          _selectedRow = -1;
                                        }
                                      });

                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Đã xóa Tác giả ${readyDeleteTacGia.tenTacGia.capitalizeFirstLetterOfEachWord()}.',
                                            textAlign: TextAlign.center,
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          width: 400,
                                        ),
                                      );
                                    },
                                    child: const Text('Có'),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: const Icon(Icons.delete),
                    style: myIconButtonStyle,
                  ),
                  const Gap(12),
                  /* 
                    Nút "Sửa thông tin Độc Giả" 
                    Logic xử lý _logicEditReader xem ở phần khai báo bên trên
                    */
                  IconButton.filled(
                    onPressed: _selectedRow == -1
                        ? null
                        : () async {
                            String? updatedTenTacGia = await showDialog(
                              context: context,
                              builder: (ctx) => EditTenTacGia(
                                  tenTacGia: _tacGias[_selectedRow].tenTacGia),
                            );

                            if (updatedTenTacGia != null) {
                              setState(() {
                                _tacGias[_selectedRow].tenTacGia =
                                    updatedTenTacGia.toLowerCase();
                              });
                              if (mounted) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Cập nhật tên Tác giả thành công.',
                                      textAlign: TextAlign.center,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    width: 400,
                                  ),
                                );
                              }
                              /* Kh cần await */
                              dbProcess.updateTacGia(
                                _tacGias[_selectedRow].maTacGia,
                                _tacGias[_selectedRow].tenTacGia,
                              );
                            }
                          },
                    icon: const Icon(Icons.edit),
                    style: myIconButtonStyle,
                  ),
                ],
              ),
              const Gap(10),
              Expanded(
                child: ClipRRect(
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
                              width: 200,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30, right: 15),
                                child: Text(
                                  'Mã Tác giả',
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
                                  'Tên Tác giả',
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
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 30,
                                ),
                                child: Text(
                                  'Số lượng sách',
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
                            _filteredTacGias.length,
                            (index) {
                              bool isTenTacGiaHover = false;
                              return Column(
                                children: [
                                  Ink(
                                    color: _selectedRow == index
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.1)
                                        : null,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 30,
                                                right: 15,
                                              ),
                                              child: Text(
                                                _filteredTacGias[index]
                                                    .maTacGia
                                                    .toString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: StatefulBuilder(builder:
                                                (ctx, setStateInkWell) {
                                              return InkWell(
                                                /* Phải có phương thức onTap thì onHover mới có tác dụng */
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        TatCaSachCuaTacGia(
                                                      tacGia: _filteredTacGias[
                                                          index],
                                                    ),
                                                  );
                                                },
                                                onHover: (value) {
                                                  if (value !=
                                                      isTenTacGiaHover) {
                                                    setStateInkWell(
                                                      () => isTenTacGiaHover =
                                                          value,
                                                    );
                                                  }
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      const SizedBox(
                                                          height: 54),
                                                      Expanded(
                                                        child: Text(
                                                          _filteredTacGias[
                                                                  index]
                                                              .tenTacGia
                                                              .capitalizeFirstLetterOfEachWord(),
                                                        ),
                                                      ),
                                                      const Gap(12),
                                                      if (isTenTacGiaHover)
                                                        const Icon(Icons
                                                            .open_in_new_rounded),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                                right: 30,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _filteredTacGias[index]
                                                          .soLuongSach
                                                          .toString(),
                                                    ),
                                                  ),
                                                  const Gap(10),
                                                  if (_selectedRow == index)
                                                    Icon(
                                                      Icons.check,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < _filteredTacGias.length - 1)
                                    const Divider(
                                      height: 0,
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
