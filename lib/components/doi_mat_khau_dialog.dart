import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/common_variables.dart';

class DoiMatKhauDialog extends StatefulWidget {
  const DoiMatKhauDialog({super.key});

  @override
  State<DoiMatKhauDialog> createState() => _DoiMatKhauDialogState();
}

class _DoiMatKhauDialogState extends State<DoiMatKhauDialog> {
  final _matKhauCuHoacPinController = TextEditingController();
  final _matKhauMoiController = TextEditingController();

  bool _isProcessing = false;
  String _errorText = '';

  void _doiMatKhau() async {
    _errorText = '';

    if (_matKhauCuHoacPinController.text.isEmpty) {
      setState(() {
        _errorText = 'Bạn chưa nhập Mật khẩu cũ hoặc mã PIN';
      });
      return;
    }

    if (_matKhauMoiController.text.isEmpty) {
      setState(() {
        _errorText = 'Bạn chưa nhập ';
      });
      return;
    }

    if (_matKhauMoiController.text.length < 6) {
      setState(() {
        _errorText = 'Mật khẩu mới phải có ít nhất 6 ký tự';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    String passwordAdmin = (await dbProcess.queryAccount())['password'];
    String maPin = await dbProcess.queryPinCode();

    if (_matKhauCuHoacPinController.text == passwordAdmin ||
        _matKhauCuHoacPinController.text == maPin) {
      /* Cập nhật lại mật khẩu cho tài khoản admin */
      await dbProcess.updateAdminPassword(_matKhauMoiController.text);
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        /* Hiện thông báo "Đổi mật khẩu thành công" */
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đổi mật khẩu thành công.'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            width: 300,
          ),
        );
        /* Đóng Dialog */
        Navigator.of(context).pop();
      }
    } else {
      _errorText = 'Mật khẩu cũ hoặc mã PIN không đúng';
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void dispose() {
    _matKhauCuHoacPinController.dispose();
    _matKhauMoiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 25,
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
                    'Mật khẩu cũ hoặc mã PIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _matKhauCuHoacPinController,
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
            const Gap(14),
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
                    'Mật khẩu mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _matKhauMoiController,
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
            const Gap(20),
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
                    onPressed: _doiMatKhau,
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
