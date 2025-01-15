import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/error_dialog.dart';
import 'package:readers/components/my_search_bar.dart';
import 'package:readers/features/the_loai_management/cubit/the_loai_management_cubit.dart';
import 'package:readers/features/the_loai_management/cubit/the_loai_management_state.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';
import 'package:readers/screens/book_manage/quan_ly_the_loai/edit_ten_the_loai.dart';
import 'package:readers/screens/book_manage/quan_ly_the_loai/tat_ca_sach_thuoc_the_loai.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';

class QuanLyTheLoai extends StatefulWidget {
  const QuanLyTheLoai({super.key});

  @override
  State<QuanLyTheLoai> createState() => _QuanLyTheLoaiState();
}

class _QuanLyTheLoaiState extends State<QuanLyTheLoai> {
  late List<TheLoaiDto> _filteredTheLoais;
  int _selectedRow = -1;
  final _searchController = TextEditingController();
  final _themTheLoaiController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<TheLoaiManagementCubit>().getTheLoaiList();
  }

  void handleDelete(int maTheLoai) async {
    context.read<TheLoaiManagementCubit>().deleteTheLoai(maTheLoai);
  }

  void _addTheLoai(List<TheLoaiDto> theLoais) async {
    final tenTheLoai = _themTheLoaiController.text.trim();
    if (tenTheLoai.isEmpty) {
      return;
    }

    final tenTheLoaiInThuong = tenTheLoai.toLowerCase();

    /* Kiểm tra tenTheLoai được nhập đã tồn tại chưa */
    for (var theLoai in theLoais) {
      if (theLoai.tenTheLoai == tenTheLoaiInThuong) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                /* 
                Sử dụng theLoai.tenTheLoai thay vì tenTheLoai ở dòng 34
                vì theLoai.tenTheLoai đã được chuẩn hóa
                */
                Text(
                  'Thể loại ${theLoai.tenTheLoai.capitalizeFirstLetter()} đã tồn tại.',
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Text(
                  'Mã thể loại: ${theLoai.maTheLoai}',
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

    await context
        .read<TheLoaiManagementCubit>()
        .addTheLoai(TheLoaiDto(0, tenTheLoaiInThuong, 0));

    _themTheLoaiController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Thêm thể loại thành công',
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
    return BlocConsumer<TheLoaiManagementCubit, TheLoaiManagementState>(
        listenWhen: (previous, current) => current.errorMessage.isNotEmpty,
        listener: (ctx, state) {
          if (state.errorMessage.isNotEmpty) {
            showDialog(
              context: context,
              builder: (ctx) => ErrorDialog(errorMessage: state.errorMessage),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return _buildInProgressWidget();
          }
          if (state.theLoais != null) {
            return _buildTheLoaiManagement(state.theLoais!);
          }
          if (state.errorMessage.isNotEmpty) {
            return _buildFailureWidget(state.errorMessage);
          }
          return const SizedBox();
        });
  }

  Widget _buildInProgressWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        Gap(14),
        Text(
          'Đang xử lý ...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Gap(50),
      ],
    );
  }

  Widget _buildFailureWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTheLoaiManagement(List<TheLoaiDto> theLoais) {
    String searchText = _searchController.text.toLowerCase();
    if (searchText.isEmpty) {
      _filteredTheLoais = List.of(theLoais);
    } else {
      _filteredTheLoais = theLoais.where((element) {
        if (element.maTheLoai.toString().contains(searchText) ||
            element.tenTheLoai.toLowerCase().contains(searchText)) {
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
              if (_searchController.text == value) {
                setState(() {});
              }
            },
          ),
          const Gap(20),
          Row(
            children: [
              const Text(
                'Danh sách Thể loại',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _themTheLoaiController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 245, 246, 250),
                    hintText: 'Tên thể loại',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 81, 81, 81),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  ),
                  onEditingComplete: () {
                    _addTheLoai(theLoais);
                  },
                ),
              ),
              const Gap(12),
              FilledButton.icon(
                onPressed: () {
                  _addTheLoai(theLoais);
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm Thể loại'),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                ),
              ),
              const Gap(12),
              IconButton.filled(
                onPressed: (_selectedRow == -1)
                    ? null
                    : () async {
                        final readyDeleteTheLoai =
                            _filteredTheLoais[_selectedRow];
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Xác nhận'),
                            content: Text(
                                'Bạn có chắc xóa Thể loại ${readyDeleteTheLoai.tenTheLoai.capitalizeFirstLetter()}?'),
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
                                  handleDelete(readyDeleteTheLoai.maTheLoai);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Đã xóa Thể loại ${readyDeleteTheLoai.tenTheLoai.capitalizeFirstLetter()}.',
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
                        await showDialog(
                          context: context,
                          builder: (ctx) =>
                              EditTenTheLoai(theLoai: theLoais[_selectedRow]),
                        );
                        setState(() {
                          _selectedRow = -1;
                          context
                              .read<TheLoaiManagementCubit>()
                              .getTheLoaiList();
                        });
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
                              'Mã Thể loại',
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
                              'Tên Thể loại',
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
                        _filteredTheLoais.length,
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
                                            _filteredTheLoais[index]
                                                .maTheLoai
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: StatefulBuilder(
                                            builder: (ctx, setStateInkWell) {
                                          return InkWell(
                                            /* Phải có phương thức onTap thì onHover mới có tác dụng */
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) =>
                                                    TatCaSachThuocTheLoai(
                                                  theLoai:
                                                      _filteredTheLoais[index],
                                                ),
                                              );
                                            },
                                            onHover: (value) {
                                              if (value != isTenTacGiaHover) {
                                                setStateInkWell(
                                                  () =>
                                                      isTenTacGiaHover = value,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 15,
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(height: 54),
                                                  Expanded(
                                                    child: Text(
                                                      _filteredTheLoais[index]
                                                          .tenTheLoai
                                                          .capitalizeFirstLetter(),
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
                                                  _filteredTheLoais[index]
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
                              if (index < _filteredTheLoais.length - 1)
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
  }
}
