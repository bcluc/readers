import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LabelTextFieldDatePicker extends StatelessWidget {
  const LabelTextFieldDatePicker({
    super.key,
    required this.labelText,
    required this.controller,
    this.firstDate,
    this.initialDateInPicker,
    this.lastDate,
  });

  final String labelText;
  final TextEditingController controller;
  final DateTime? firstDate;
  final DateTime? initialDateInPicker;
  final DateTime? lastDate;

  Future<void> openDatePicker(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: initialDateInPicker ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
    );
    if (chosenDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(chosenDate);
    }
  }

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
        GestureDetector(
          onTap: () => openDatePicker(context),
          child: TextFormField(
            controller: controller,
            enabled: false,
            mouseCursor: SystemMouseCursors.click,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 245, 246, 250),
              hintText: 'dd/MM/yyyy',
              hintStyle: const TextStyle(color: Color(0xFF888888)),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.all(14),
              isCollapsed: true,
              suffixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bạn chưa nhập $labelText'; // 68 44
              }
              return null;
            },
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
