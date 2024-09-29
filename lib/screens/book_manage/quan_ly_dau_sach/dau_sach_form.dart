import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/cubit/selected_tac_gia_cubit.dart';
import 'package:readers/cubit/selected_the_loai_cubit.dart';
import 'package:readers/dto/dau_sach_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/models/tac_gia.dart';
import 'package:readers/models/the_loai.dart';
import 'package:readers/utils/extension.dart';

class DauSachForm extends StatefulWidget {
  const DauSachForm({
    super.key,
    this.editDauSach,
  });

  final DauSachDto? editDauSach;

  @override
  State<DauSachForm> createState() => _DauSachFormState();
}

class _DauSachFormState extends State<DauSachForm> {
  final _formKey = GlobalKey<FormState>();
  final _tenDauSachController = TextEditingController();

  bool _isProcessing = false;

  void _saveDauSach() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      await Future.delayed(const Duration(microseconds: 200));

      if (widget.editDauSach == null) {
        DauSachDto newDauSachDto = DauSachDto(
          null,
          _tenDauSachController.text,
          0,
          // ignore: use_build_context_synchronously
          context.read<SelectedTacGiaCubit>().state,
          // ignore: use_build_context_synchronously
          context.read<SelectedTheLoaiCubit>().state,
        );

        int returningId = await dbProcess.insertDauSachDto(newDauSachDto);
        newDauSachDto.maDauSach = returningId;

        if (mounted) {
          Navigator.of(context).pop(newDauSachDto);
        }
      } else {
        widget.editDauSach!.tenDauSach = _tenDauSachController.text;
        // ignore: use_build_context_synchronously
        widget.editDauSach!.tacGias = context.read<SelectedTacGiaCubit>().state;
        // ignore: use_build_context_synchronously
        widget.editDauSach!.theLoais =
            context.read<SelectedTheLoaiCubit>().state;

        await dbProcess.updateDauSachDto(widget.editDauSach!);

        if (mounted) {
          Navigator.of(context).pop('updated');
        }
      }

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editDauSach == null
                ? 'Tạo Đầu sách thành công.'
                : 'Cập nhật thông tin thành công'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 300,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editDauSach != null) {
      _tenDauSachController.text = widget.editDauSach!.tenDauSach;
    }
  }

  @override
  void dispose() {
    _tenDauSachController.dispose();
    super.dispose();
  }

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
        child: SizedBox.expand(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.editDauSach == null
                        ? 'THÊM ĐẦU SÁCH MỚI'
                        : 'SỬA ĐẦU SÁCH',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: LabelTextFormField(
                  controller: _tenDauSachController,
                  labelText: 'Tên Đầu sách',
                ),
              ),
              const Gap(12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Tác giả',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<SelectedTacGiaCubit, List<TacGia>>(
                        builder: (ctx, tacGias) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              tacGias.length,
                              (index) {
                                bool isTacGiaHover = false;
                                return StatefulBuilder(
                                  builder: (ctx, setStateTacGiaItem) {
                                    return MouseRegion(
                                      onEnter: (_) => setStateTacGiaItem(
                                        () => isTacGiaHover = true,
                                      ),
                                      onHover: (_) {
                                        if (isTacGiaHover == false) {
                                          setStateTacGiaItem(
                                            () => isTacGiaHover = true,
                                          );
                                        }
                                      },
                                      onExit: (_) => setStateTacGiaItem(
                                        () => isTacGiaHover = false,
                                      ),
                                      child: Ink(
                                        padding: const EdgeInsets.fromLTRB(
                                            16, 4, 24, 4),
                                        color: isTacGiaHover
                                            ? Colors.grey.withOpacity(0.1)
                                            : Colors.transparent,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              height: 40,
                                            ),
                                            Expanded(
                                              child: Text(tacGias[index]
                                                  .tenTacGia
                                                  .capitalizeFirstLetterOfEachWord()),
                                            ),
                                            const Gap(12),
                                            if (isTacGiaHover)
                                              IconButton(
                                                onPressed: () {
                                                  context
                                                      .read<
                                                          SelectedTacGiaCubit>()
                                                      .remove(tacGias[index]);
                                                },
                                                icon: const Icon(
                                                    Icons.horizontal_rule),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const Gap(12),
                      const Text(
                        'Thể loại',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      BlocBuilder<SelectedTheLoaiCubit, List<TheLoai>>(
                          builder: (ctx, theLoais) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            theLoais.length,
                            // (index) => Text(theLoais[index].tenTheLoai.capitalizeFirstLetter()),
                            (index) {
                              bool isTheLoaiHover = false;
                              return StatefulBuilder(
                                builder: (ctx, setStateTheLoaiItem) {
                                  return MouseRegion(
                                    onEnter: (_) => setStateTheLoaiItem(
                                      () => isTheLoaiHover = true,
                                    ),
                                    onHover: (_) {
                                      if (isTheLoaiHover == false) {
                                        setStateTheLoaiItem(
                                          () => isTheLoaiHover = true,
                                        );
                                      }
                                    },
                                    onExit: (_) => setStateTheLoaiItem(
                                      () => isTheLoaiHover = false,
                                    ),
                                    child: Ink(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 4, 24, 4),
                                      color: isTheLoaiHover
                                          ? Colors.grey.withOpacity(0.1)
                                          : Colors.transparent,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          Expanded(
                                            child: Text(theLoais[index]
                                                .tenTheLoai
                                                .capitalizeFirstLetter()),
                                          ),
                                          const Gap(12),
                                          if (isTheLoaiHover)
                                            IconButton(
                                              onPressed: () {
                                                context
                                                    .read<
                                                        SelectedTheLoaiCubit>()
                                                    .remove(theLoais[index]);
                                              },
                                              icon: const Icon(
                                                  Icons.horizontal_rule),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              _isProcessing
                  ? const SizedBox(
                      height: 44,
                      width: 44,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : FilledButton(
                      onPressed: _saveDauSach,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                      ),
                      child: const Text(
                        'Lưu',
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
