import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/cubit/selected_tac_gia_cubit.dart';
import 'package:readers/main.dart';
import 'package:readers/models/tac_gia.dart';
import 'package:readers/utils/extension.dart';

class TacGiaForm extends StatefulWidget {
  const TacGiaForm({
    super.key,
  });

  @override
  State<TacGiaForm> createState() => _TacGiaFormState();
}

class _TacGiaFormState extends State<TacGiaForm> {
  late final List<TacGia> _tacGias;
  late List<TacGia> _filteredTacGias;

  late final Future<void> _futureTacGias = _getTacGias();
  Future<void> _getTacGias() async {
    _tacGias = await dbProcess.queryTacGias();
  }

  final _themTacGiaController = TextEditingController();
  final _timTacTacController = TextEditingController();

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

            String searchText = _timTacTacController.text;
            if (searchText.isEmpty) {
              _filteredTacGias = List.of(_tacGias);
            } else {
              _filteredTacGias = _tacGias
                  .where((element) => element.tenTacGia
                      .toLowerCase()
                      .contains(searchText.toLowerCase()))
                  .toList();
            }

            return Column(
              children: [
                const Text(
                  'TÁC GIẢ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _themTacGiaController,
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
                      hintText: 'Thêm Tác giả',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    ),
                    onEditingComplete: () async {
                      // Thêm Tác Giả mới vào Database
                      TacGia newTacGia = TacGia(
                        null,
                        _themTacGiaController.text,
                      );
                      int returningId = await dbProcess.insertTacGia(newTacGia);
                      newTacGia.maTacGia = returningId;

                      /* Cập nhật lại danh sách Tác Giả */
                      setState(() {
                        _tacGias.insert(0, newTacGia);
                        _themTacGiaController.clear();
                      });
                    },
                  ),
                ),
                /* Tìm kiếm Tác Giả */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _timTacTacController,
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
                      hintText: 'Tìm tên Tác giả',
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
                /* Danh sách Tác Giả */
                Expanded(
                  child: ListView(
                    children: List.generate(
                      _filteredTacGias.length,
                      (index) {
                        TacGia tacGia = _filteredTacGias[index];
                        bool isHover = false;
                        return StatefulBuilder(
                          builder: (ctx, setStateListItem) {
                            return MouseRegion(
                              onEnter: (_) => setStateListItem(
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
                                    Text(_filteredTacGias[index]
                                        .tenTacGia
                                        .capitalizeFirstLetterOfEachWord()),
                                    const Spacer(),
                                    if (isHover)
                                      BlocBuilder<SelectedTacGiaCubit,
                                              List<TacGia>>(
                                          builder: (ctx, selectedTacGias) {
                                        bool isSelected = false;
                                        for (var selectedTacGia
                                            in selectedTacGias) {
                                          if (selectedTacGia.maTacGia ==
                                              tacGia.maTacGia) {
                                            isSelected = true;
                                            break;
                                          }
                                        }

                                        return AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 200),
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
                                                            SelectedTacGiaCubit>()
                                                        .add(tacGia);

                                                    setStateListItem(() {});
                                                  },
                                                  icon: const Icon(Icons.check),
                                                )
                                              : IconButton(
                                                  key: const ValueKey(
                                                      'remove-button'),
                                                  onPressed: () {
                                                    context
                                                        .read<
                                                            SelectedTacGiaCubit>()
                                                        .remove(tacGia);

                                                    setStateListItem(() {});
                                                  },
                                                  icon: const Icon(
                                                      Icons.horizontal_rule),
                                                ),
                                        );
                                      }),
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
