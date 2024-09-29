import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/common_variables.dart';

class DoiMaPin extends StatefulWidget {
  const DoiMaPin({super.key});

  @override
  State<DoiMaPin> createState() => _DoiMaPinState();
}

class _DoiMaPinState extends State<DoiMaPin> {
  final _maPinMoi = TextEditingController();

  bool _isProcessing = false;
  String _errorText = '';

  void _doiMaPin() async {
    _errorText = '';

    if (_maPinMoi.text.isEmpty) {
      setState(() {
        _errorText = 'Bạn chưa nhập Mã PIN';
      });
      return;
    }

    if (_maPinMoi.text.length < 6) {
      setState(() {
        _errorText = 'Mã PIN mới phải có ít nhất 6 ký tự';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    /* Cập nhật lại Mã PIN của app */
    await dbProcess.updateMaPin(_maPinMoi.text);
    await Future.delayed(const Duration(milliseconds: 200));

    if (mounted) {
      /* Hiện thông báo "Đổi Mã PIN thành công" */
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đổi Mã PIN thành công.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 300,
        ),
      );
      /* Đóng Dialog */
      Navigator.of(context).pop();
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _maPinMoi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Đổi Mật khẩu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(24),
            Container(
              width: screenWidth * 0.35,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Màu sắc của border
                  width: 1, // Độ rộng của border
                ),
                borderRadius: BorderRadius.circular(10), // Bán kính của border
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã PIN mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _maPinMoi,
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      isCollapsed: true,
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            const Gap(10),
            Text(
              _errorText,
              style: errorTextStyle(context),
            ),
            const Gap(28),
            _isProcessing
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : FilledButton(
                    onPressed: _doiMaPin,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 18),
                      foregroundColor: Colors.white,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Đổi',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Gap(8),
                        Icon(Icons.change_circle)
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
