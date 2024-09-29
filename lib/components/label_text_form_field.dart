import 'package:flutter/material.dart';

class LabelTextFormField extends StatelessWidget {
  const LabelTextFormField({
    super.key,
    required this.labelText,
    this.controller,
    this.isEnable = true,
    this.hint = "",
    this.initText,
    this.onEditingComplete,
    this.customValidator,
    this.onTap,
    this.suffixText,
  });

  final String labelText;
  final TextEditingController? controller;
  final bool isEnable;
  final String hint;
  final String? initText;
  final String? Function(String?)? customValidator;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final String? suffixText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: isEnable,
          initialValue: initText,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEnable ? const Color.fromARGB(255, 245, 246, 250) : const Color(0xffEFEFEF),
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF888888)),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(14),
            isCollapsed: true,
            suffixText: suffixText,
            errorMaxLines: 2,
          ),
          validator: customValidator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Bạn chưa nhập $labelText';
                }
                return null;
              },
          onEditingComplete: onEditingComplete,
          onTap: onTap,
        ),
      ],
    );
  }
}
