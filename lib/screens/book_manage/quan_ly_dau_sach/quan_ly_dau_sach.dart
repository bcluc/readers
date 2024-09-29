import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/my_search_bar.dart';
import 'package:readers/dto/dau_sach_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/book_manage/quan_ly_dau_sach/add_edit_dau_sach_form.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

class QuanLyDauSach extends StatefulWidget {
  const QuanLyDauSach({super.key});

  @override
  State<QuanLyDauSach> createState() => _QuanLyDauSachState();
}

class _QuanLyDauSachState extends State<QuanLyDauSach> {
  late final List<DauSachDto> _dauSachs;
  late List<DauSachDto> _filteredDauSachs;

  int _selectedRow = -1;

  final _searchController = TextEditingController();

  late final Future<void> _futureDauSachs = _getDauSachs();
  Future<void> _getDauSachs() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _dauSachs = await dbProcess.queryDauSachDto();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureDauSachs,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        String searchText = _searchController.text.toLowerCase();
        if (searchText.isEmpty) {
          _filteredDauSachs = List.of(_dauSachs);
        } else {
          _filteredDauSachs = _dauSachs.where((element) {
            if (element.tenDauSach.toLowerCase().contains(searchText) ||
                element.tacGiasToString().toLowerCase().contains(searchText) ||
                element.theLoaisToString().toLowerCase().contains(searchText)) {
              return true;
            }
            return false;
          }).toList();
        }

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
                  }
                },
              ),
              const Gap(20),
              Row(
                children: [
                  const Text(
                    'Danh sách Đầu Sách',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () async {
                      // Xử lý Thêm Đầu Sách
                      DauSachDto? newDauSachDto = await showDialog(
                        context: context,
                        builder: (ctx) => const AddEditDauSachForm(),
                      );

                      if (newDauSachDto != null) {
                        setState(() {
                          _dauSachs.add(newDauSachDto);
                        });
                      }
                    },
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm đầu sách'),
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
                    onPressed: (_selectedRow == -1 ||
                            _filteredDauSachs[_selectedRow].soLuong != 0)
                        ? null
                        : () async {
                            final readyDeleteDauSach =
                                _filteredDauSachs[_selectedRow];
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Xác nhận'),
                                content: Text(
                                    'Bạn có chắc xóa Đầu sách ${readyDeleteDauSach.tenDauSach}?'),
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
                                    onPressed: () async {
                                      await dbProcess.deleteDauSachWithId(
                                          readyDeleteDauSach.maDauSach!);

                                      setState(() {
                                        _dauSachs.removeWhere((element) =>
                                            element.maDauSach ==
                                            readyDeleteDauSach.maDauSach);
                                        _filteredDauSachs
                                            .removeAt(_selectedRow);
                                        /*
                                        Phòng trường hợp khi _selectedRow đang ở cuối bảng và ta nhấn xóa dòng cuối của bảng
                                        Lúc này _selectedRow đã nằm ngoài mảng, và nút "Xóa" vẫn chưa được Disable
                                        => Có khả năng gây ra lỗi
                                        Solution: Sau khi xóa phải kiểm tra lại 
                                        xem _selectedRow có nằm ngoài phạm vi của _filteredDauSachs hay không.
                                        */
                                        if (_selectedRow >=
                                            _filteredDauSachs.length) {
                                          _selectedRow = -1;
                                        }
                                      });
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Đã xóa Đầu sách ${readyDeleteDauSach.tenDauSach}.',
                                              textAlign: TextAlign.center,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            width: 400,
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Có'),
                                  ),
                                ],
                              ),
                            );
                          },
                    icon: const Icon(Icons.delete),
                    style: myIconButtonStyle,
                    tooltip:
                        'Chỉ có thể xóa những Đầu sách có số lượng bằng 0.',
                  ),
                  const Gap(12),
                  /* 
                    Nút "Sửa thông tin Đầu sách" 
                    Logic xử lý _logicEditReader xem ở phần khai báo bên trên
                    */
                  IconButton.filled(
                    onPressed: _selectedRow == -1
                        ? null
                        : () async {
                            String? message = await showDialog(
                              context: context,
                              builder: (ctx) => AddEditDauSachForm(
                                editDauSach: _filteredDauSachs[_selectedRow],
                              ),
                            );

                            if (message == 'updated') {
                              setState(() {});
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
                          horizontal: 30,
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 80,
                              child: Text(
                                '#',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  'Thể loại',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Số lượng',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: List.generate(
                            _filteredDauSachs.length,
                            (index) {
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
                                      onLongPress: () async {
                                        setState(() {
                                          _selectedRow = index;
                                        });
                                        String? message = await showDialog(
                                          context: context,
                                          builder: (ctx) => AddEditDauSachForm(
                                            editDauSach:
                                                _filteredDauSachs[_selectedRow],
                                          ),
                                        );

                                        if (message == 'updated') {
                                          setState(() {});
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Gap(30),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              (index + 1).toString(),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 15,
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index]
                                                    .tenDauSach
                                                    .capitalizeFirstLetterOfEachWord(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index]
                                                    .tacGiasToString(),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Text(
                                                _filteredDauSachs[index]
                                                    .theLoaisToString(),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _filteredDauSachs[index]
                                                        .soLuong
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
                                          const Gap(30),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (index < _filteredDauSachs.length - 1)
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
