import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/components/label_text_form_field_datepicker.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';

class NgayMuonHanTra extends StatefulWidget {
  const NgayMuonHanTra({super.key, required this.ngayMuonController});

  final TextEditingController ngayMuonController;

  @override
  State<NgayMuonHanTra> createState() => _NgayMuonHanTraState();
}

class _NgayMuonHanTraState extends State<NgayMuonHanTra> {
  @override
  void initState() {
    super.initState();
    widget.ngayMuonController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Expanded(
            child: LabelTextFieldDatePicker(
              labelText: 'Ngày mượn',
              controller: widget.ngayMuonController,
            ),
          ),
          const Gap(30),
          Expanded(
            child: LabelTextFormField(
              labelText: 'Hạn trả',
              initText: vnDateFormat
                  .parse(widget.ngayMuonController.text)
                  .addDays(ThamSoQuyDinh.soNgayMuonToiDa)
                  .toVnFormat(),
              isEnable: false,
            ),
          ),
        ],
      ),
    );
  }
}
