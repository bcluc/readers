import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:readers/components/label_text_form_field_datepicker.dart';
import 'package:readers/components/label_text_form_field.dart';
import 'package:readers/main.dart';
import 'package:readers/models/doc_gia.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/extension.dart';
import 'package:readers/utils/parameters.dart';

class AddEditDocGiaForm extends StatefulWidget {
  const AddEditDocGiaForm({
    super.key,
    this.editDocGia,
  });

  final DocGia? editDocGia;

  @override
  State<AddEditDocGiaForm> createState() => _AddEditDocGiaFormState();
}

class _AddEditDocGiaFormState extends State<AddEditDocGiaForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _fullnameController = TextEditingController();

  final _dobController = TextEditingController();

  final _addressController = TextEditingController();

  final _phoneController = TextEditingController();

  final _creationDateController = TextEditingController();

  final _expirationDateController = TextEditingController();

  final _totalTiabilitiesController = TextEditingController();

  void setCreationExpriationDate(DateTime date) {
    _creationDateController.text = date.toVnFormat();
    _expirationDateController.text =
        date.addMonths(ThamSoQuyDinh.thoiHanThe).toVnFormat();
  }

  void saveDocGia(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      if (widget.editDocGia == null) {
        DocGia newDocGia = DocGia(
          null,
          _fullnameController.text.toLowerCase(),
          vnDateFormat.parse(_dobController.text),
          _addressController.text,
          _phoneController.text,
          vnDateFormat.parse(_creationDateController.text),
          vnDateFormat.parse(_expirationDateController.text),
        );

        int returningId = await dbProcess.insertDocGia(newDocGia);
        newDocGia.maDocGia = returningId;

        if (mounted) {
          Navigator.of(context).pop(newDocGia);
        }
      } else {
        widget.editDocGia!.hoTen = _fullnameController.text.toLowerCase();
        widget.editDocGia!.ngaySinh = vnDateFormat.parse(_dobController.text);
        widget.editDocGia!.diaChi = _addressController.text;
        widget.editDocGia!.soDienThoai = _phoneController.text;
        widget.editDocGia!.ngayLapThe =
            vnDateFormat.parse(_creationDateController.text);
        widget.editDocGia!.ngayHetHan =
            vnDateFormat.parse(_expirationDateController.text);

        await dbProcess.updateDocGia(widget.editDocGia!);

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
            content: Text(widget.editDocGia == null
                ? 'Tạo thẻ độc giả thành công.'
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
    if (widget.editDocGia != null) {
      /*
      Nếu là chỉnh sửa độc giả
      thì phải fill thông tin vào của độc giả cần chỉnh sửa vào form
      */
      _fullnameController.text =
          widget.editDocGia!.hoTen.capitalizeFirstLetterOfEachWord();
      _dobController.text = widget.editDocGia!.ngaySinh.toVnFormat();
      _addressController.text = widget.editDocGia!.diaChi;
      _phoneController.text = widget.editDocGia!.soDienThoai;
      _addressController.text = widget.editDocGia!.diaChi;
      _creationDateController.text = widget.editDocGia!.ngayLapThe.toVnFormat();
      _expirationDateController.text =
          widget.editDocGia!.ngayHetHan.toVnFormat();
    } else {
      /* 
      Nếu là thêm mới Độc Giả, thì thiết lập sẵn Creation và ExpriationDate 
      CreationDate là DateTime.now()
      ExpriationDate là DateTime.now() + 6 tháng 
      */
      setCreationExpriationDate(DateTime.now());
    }
  }

  @override
  void dispose() {
    /* dispose các controller để tránh lãng phí bộ nhớ */
    _fullnameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _creationDateController.dispose();
    _expirationDateController.dispose();
    _totalTiabilitiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.editDocGia == null
                          ? 'TẠO THẺ ĐỘC GIẢ'
                          : 'SỬA THẺ ĐỘC GIẢ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Họ Tên',
                  controller: _fullnameController,
                ),
                //
                const SizedBox(height: 10),
                LabelTextFieldDatePicker(
                  labelText: 'Ngày sinh',
                  controller: _dobController,
                  initialDateInPicker: widget.editDocGia != null
                      ? widget.editDocGia!.ngaySinh
                      : DateTime.now().subYears(ThamSoQuyDinh.tuoiToiThieu),
                  lastDate: DateTime.now().subYears(ThamSoQuyDinh.tuoiToiThieu),
                ),
                //
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Địa chỉ',
                  controller: _addressController,
                ),
                //
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Số điện thoại',
                  controller: _phoneController,
                ),
                //
                const SizedBox(height: 10),
                const Text(
                  'Ngày lập thẻ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () async {
                    DateTime? chosenDate = await showDatePicker(
                      context: context,
                      initialDate: widget.editDocGia != null
                          ? widget.editDocGia!.ngayLapThe
                          : DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (chosenDate != null) {
                      setCreationExpriationDate(chosenDate);
                    }
                  },
                  child: TextFormField(
                    controller: _creationDateController,
                    enabled: false,
                    mouseCursor: SystemMouseCursors.click,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 245, 246, 250),
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
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                //
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Ngày hết hạn',
                  isEnable: false,
                  controller: _expirationDateController,
                ),
                if (widget.editDocGia == null) ...[
                  const SizedBox(height: 10),
                  Text(
                    '*Thu tiền tạo thẻ ${ThamSoQuyDinh.phiTaoThe.toVnCurrencyFormat()}',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  )
                ],
                const SizedBox(height: 50),
                Align(
                  alignment: Alignment.center,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 44,
                          width: 44,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FilledButton(
                          onPressed: () => saveDocGia(context),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
