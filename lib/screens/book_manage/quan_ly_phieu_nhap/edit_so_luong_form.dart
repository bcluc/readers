import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditSoLuongForm extends StatelessWidget {
  EditSoLuongForm({
    super.key,
    required this.soLuong,
  });

  final int soLuong;

  final _formKey = GlobalKey<FormState>();

  late final _soLuongCuonSachController = TextEditingController(
    text: soLuong.toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 490,
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
                    'Số Lượng Nhập',
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
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _soLuongCuonSachController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Số Lượng';
                    }
                    int? soLuongInt = int.tryParse(value);
                    if (soLuongInt == null) {
                      return 'Số Lượng không hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(20),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop(int.parse(_soLuongCuonSachController.text));
                    }
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
