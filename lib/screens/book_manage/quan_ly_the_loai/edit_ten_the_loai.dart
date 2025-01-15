import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:readers/features/the_loai_management/cubit/the_loai_management_cubit.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';

class EditTenTheLoai extends StatefulWidget {
  const EditTenTheLoai({
    super.key,
    required this.theLoai,
  });

  final TheLoaiDto theLoai;

  @override
  State<EditTenTheLoai> createState() => _EditTenTheLoaiState();
}

class _EditTenTheLoaiState extends State<EditTenTheLoai> {
  final tenTheLoaiController = TextEditingController();
  void handleEditTheLoai(BuildContext context) async {
    try {
      widget.theLoai.tenTheLoai = tenTheLoaiController.text;
      await context
          .read<TheLoaiManagementCubit>()
          .updateTheLoai(widget.theLoai);

      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thể loại thành công'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tenTheLoaiController.text = widget.theLoai.tenTheLoai;
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
                    'Tên Thể Loại',
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
                controller: tenTheLoaiController,
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
                    handleEditTheLoai(context);
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
