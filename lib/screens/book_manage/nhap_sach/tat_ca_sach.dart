import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/error_dialog.dart';
import 'package:readers/components/my_search_bar.dart';
import 'package:readers/features/sach_management/cubit/sach_management_cubit.dart';
import 'package:readers/features/sach_management/cubit/sach_management_state.dart';
import 'package:readers/models/sach.dart';
import 'package:readers/utils/extension.dart';

class TatCaSach extends StatefulWidget {
  const TatCaSach({
    super.key,
    required this.openThemSachMoiForm,
  });

  final void Function() openThemSachMoiForm;

  @override
  State<TatCaSach> createState() => _TatCaSachDState();
}

class _TatCaSachDState extends State<TatCaSach> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    context.read<SachManagementCubit>().getSachList();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SachManagementCubit, SachManagementState>(
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
          if (state.sachs != null) {
            return _buildSachManagement(state.sachs!);
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

  Widget _buildSachManagement(List<Sach> sachs) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: SizedBox(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 30,
          ),
          child: StatefulBuilder(builder: (ctx, setStateColumn) {
            List<Sach> filteredSachs;
            if (_searchController.text.isEmpty) {
              filteredSachs = List.of(sachs);
            } else {
              filteredSachs = sachs
                  .where((element) => element.tenDauSach
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
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
                      setStateColumn(() {});
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Tất cả Sách',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: widget.openThemSachMoiForm,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Thêm mới sách'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                                width: 81,
                                child: Text(
                                  'Mã Sách',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 240,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'Tên Đầu sách',
                                    style: TextStyle(
                                      color: Colors.white,
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
                                    'Lần Tái bản',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    'NXB',
                                    style: TextStyle(
                                      color: Colors.white,
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
                              filteredSachs.length,
                              (index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Gap(30),
                                        SizedBox(
                                          width: 80,
                                          child: Text(filteredSachs[index]
                                              .maSach
                                              .toString()),
                                        ),
                                        SizedBox(
                                          width: 240,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 15,
                                            ),
                                            child: Text(filteredSachs[index]
                                                .tenDauSach
                                                .capitalizeFirstLetterOfEachWord()),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Text(filteredSachs[index]
                                                .lanTaiBan
                                                .toString()),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                            ),
                                            child: Text(filteredSachs[index]
                                                .nhaXuatBan),
                                          ),
                                        ),
                                        const Gap(30),
                                      ],
                                    ),
                                    if (index < filteredSachs.length - 1)
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
            );
          }),
        ),
      ),
    );
  }
}
