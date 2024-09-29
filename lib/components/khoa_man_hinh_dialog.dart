import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/common_variables.dart';

class KhoaManHinhDialog extends StatefulWidget {
  const KhoaManHinhDialog({super.key});

  @override
  State<KhoaManHinhDialog> createState() => _KhoaManHinhDialogState();
}

class _KhoaManHinhDialogState extends State<KhoaManHinhDialog> {
  final _matKhauController = TextEditingController();
  String _passwordAdmin = '';
  String _informText = 'Nhập Mật khẩu để mở khóa';

  void _moKhoaManHinh() async {
    if (_matKhauController.text.isEmpty) {
      setState(() {
        _informText = 'Bạn chưa nhập Mật khẩu';
      });
      return;
    }

    if (_passwordAdmin.isEmpty) {
      _passwordAdmin = (await dbProcess.queryAccount())['password'];
    }
    if (_matKhauController.text == _passwordAdmin) {
      if (mounted) {
        Navigator.of(context).pop();
      }
      await Future.delayed(const Duration(milliseconds: 100));
      _matKhauController.clear();
    } else {
      setState(() {
        _informText = 'Mật khẩu không chính xác';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _informText = 'Nhập Mật khẩu để mở khóa';
  }

  @override
  void dispose() {
    _matKhauController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            Icon(
              Icons.lock,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const Gap(20),
            Text(
              _informText,
              style: _informText != 'Nhập Mật khẩu để mở khóa'
                  ? errorTextStyle(context)
                  : null,
            ),
            const Gap(10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _matKhauController,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(color: Color(0xFF888888)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                  isCollapsed: true,
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                onEditingComplete: _moKhoaManHinh,
              ),
            ),
            const Gap(28),
            FilledButton(
              onPressed: _moKhoaManHinh,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 26,
                ),
              ),
              child: const Text(
                'Mở khóa',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
