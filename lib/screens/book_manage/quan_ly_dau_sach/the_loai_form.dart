import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/cubit/selected_the_loai_cubit.dart';
import 'package:readers/main.dart';
import 'package:readers/models/the_loai.dart';
import 'package:readers/utils/extension.dart';

class TheLoaiForm extends StatefulWidget {
  const TheLoaiForm({
    super.key,
  });

  @override
  State<TheLoaiForm> createState() => _TheLoaiFormState();
}

class _TheLoaiFormState extends State<TheLoaiForm> {
  late final List<TheLoai> _theLoais;
  late List<TheLoai> _filteredTheLoais;
  final template = TheLoai.creatNewTemplate();

  late final Future<void> _futureTacGias = _getTacGias();
  Future<void> _getTacGias() async {
    _theLoais = await dbProcess.queryTheLoais();
  }

  final _themTheLoaiController = TextEditingController();
  final _timTheLoaiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: FutureBuilder(
          future: _futureTacGias,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            String searchText = _timTheLoaiController.text.toLowerCase();
            if (searchText.isEmpty) {
              _filteredTheLoais = List.of(_theLoais);
            } else {
              _filteredTheLoais = _theLoais
                  .where((element) =>
                      element.tenTheLoai.toLowerCase().contains(searchText))
                  .toList();
            }

            return Column(
              children: [
                const Text(
                  'THỂ LOẠI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _themTheLoaiController,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                          right: 8,
                        ),
                        child: Icon(Icons.add_rounded),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        maxWidth: 32,
                      ),
                      hintText: 'Thêm Thể loại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    ),
                    onEditingComplete: () async {
                      // Thêm Tác Giả mới vào Database
                      TheLoai newTheLoai = TheLoai(
                        null,
                        _themTheLoaiController.text,
                      );
                      int returningId =
                          await dbProcess.insertTheLoai(newTheLoai.tenTheLoai);
                      newTheLoai.maTheLoai = returningId;

                      /* Cập nhật lại danh sách Tác Giả */
                      setState(() {
                        _theLoais.insert(0, newTheLoai);
                        _themTheLoaiController.clear();
                      });
                    },
                  ),
                ),
                /* Tìm kiếm Thể loại */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _timTheLoaiController,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                          right: 8,
                        ),
                        child: Icon(Icons.search),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        maxWidth: 32,
                      ),
                      hintText: 'Tìm tên Thể loại',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    ),
                    onEditingComplete: () {
                      setState(() {});
                    },
                    onChanged: (value) async {
                      if (value.isEmpty) {
                        await Future.delayed(const Duration(milliseconds: 50));
                        setState(() {});
                      }
                    },
                  ),
                ),
                /* Danh sách thể loại */
                Expanded(
                  child: ListView(
                    children: List.generate(
                      _filteredTheLoais.length,
                      (index) {
                        final theLoai = _filteredTheLoais[index];
                        bool isHover = false;

                        return StatefulBuilder(
                          builder: (ctx, setStateListItem) {
                            return MouseRegion(
                              onEnter: (event) => setStateListItem(
                                () => isHover = true,
                              ),
                              onHover: (_) {
                                if (isHover == false) {
                                  setStateListItem(
                                    () => isHover = true,
                                  );
                                }
                              },
                              onExit: (_) => setStateListItem(
                                () => isHover = false,
                              ),
                              child: Ink(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 4, 24, 4),
                                color: isHover
                                    ? Colors.grey.withOpacity(0.1)
                                    : Colors.transparent,
                                child: Row(
                                  children: [
                                    /* Thêm SizedBox height = 40 để cho mọi ListItem có chiều cao bằng nhau */
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Text(_filteredTheLoais[index]
                                        .tenTheLoai
                                        .capitalizeFirstLetter()),
                                    const Spacer(),
                                    if (isHover)
                                      BlocBuilder<SelectedTheLoaiCubit,
                                          List<TheLoai>>(
                                        builder: (ctx, selectedTheLoais) {
                                          bool isSelected = false;
                                          for (var selectedTheLoai
                                              in selectedTheLoais) {
                                            if (selectedTheLoai.maTheLoai ==
                                                theLoai.maTheLoai) {
                                              isSelected = true;
                                              break;
                                            }
                                          }
                                          return AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 200),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                            child: !isSelected
                                                ? IconButton(
                                                    key: const ValueKey(
                                                        'check-button'),
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              SelectedTheLoaiCubit>()
                                                          .add(theLoai);

                                                      setStateListItem(() {});
                                                    },
                                                    icon:
                                                        const Icon(Icons.check),
                                                  )
                                                : IconButton(
                                                    key: const ValueKey(
                                                        'remove-button'),
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                              SelectedTheLoaiCubit>()
                                                          .remove(theLoai);
                                                      setStateListItem(() {});
                                                    },
                                                    icon: const Icon(
                                                        Icons.horizontal_rule),
                                                  ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
