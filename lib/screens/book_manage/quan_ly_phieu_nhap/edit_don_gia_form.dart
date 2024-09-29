import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/utils/extension.dart';

class EditDonGiaForm extends StatelessWidget {
  EditDonGiaForm({
    super.key,
    required this.donGia,
  });

  final int donGia;

  final _formKey = GlobalKey<FormState>();

  late final _donGiaCuonSachController = TextEditingController(
    text: donGia.toVnCurrencyWithoutSymbolFormat(),
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
                    'Đơn Giá Nhập',
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
                  controller: _donGiaCuonSachController,
                  decoration: InputDecoration(
                    suffixText: 'VND',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onEditingComplete: () {
                    var text = _donGiaCuonSachController.text;
                    try {
                      _donGiaCuonSachController.text =
                          int.parse(text).toVnCurrencyWithoutSymbolFormat();
                    } catch (e) {
                      // Do nothing
                      // print('Parse FAILED');
                    }
                    FocusScope.of(context).unfocus();
                  },
                  onTap: () {
                    _donGiaCuonSachController.text =
                        _donGiaCuonSachController.text.replaceAll('.', '');
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Đơn Giá';
                    }

                    if (int.tryParse(value.replaceAll('.', '')) == null) {
                      return 'Đơn Giá phải là con số';
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
                      Navigator.of(context).pop(int.parse(
                        _donGiaCuonSachController.text.replaceAll('.', ''),
                      ));
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
