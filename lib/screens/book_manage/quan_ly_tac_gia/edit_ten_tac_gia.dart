import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/features/tac_gia_management/cubit/tac_gia_management_cubit.dart';
import 'package:readers/features/tac_gia_management/dtos/tac_gia_dto.dart';

class EditTenTacGia extends StatefulWidget {
  const EditTenTacGia({super.key, required this.tacGia});

  final TacGiaDto tacGia;

  @override
  State<EditTenTacGia> createState() => _EditTenTacGiaState();
}

class _EditTenTacGiaState extends State<EditTenTacGia> {
  final tenTacGiaController = TextEditingController();

  void handleEditTacGia(BuildContext context) async {
    try {
      widget.tacGia.tenTacGia = tenTacGiaController.text;
      await context.read<TacGiaManagementCubit>().updateTacGia(widget.tacGia);

      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật tác giả thành công'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tenTacGiaController.text = widget.tacGia.tenTacGia;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    'Tên Tác giả',
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
              TextField(
                controller: tenTacGiaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const Gap(20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    handleEditTacGia(context);
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 26,
                    ),
                  ),
                  child: const Text(
                    'Lưu',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
