import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/components/password_text_field.dart';
import 'package:readers/main.dart';
import 'package:readers/screens/library_management.dart';
import 'package:readers/utils/common_variables.dart';
// import 'package:readers/utils/parameters.dart';
import 'package:page_transition/page_transition.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
    required this.onQuenMatKhauButtonClick,
  });

  final void Function() onQuenMatKhauButtonClick;
  @override
  State<LoginView> createState() => _LoginViewState();

  validateCredentials(String s, String t) {}
}

class _LoginViewState extends State<LoginView> {
  final _usernameController = TextEditingController(text: 'admin');
  final _passwordController = TextEditingController(text: '123456');

  bool _isProcessing = false;

  Map<String, dynamic> accountToLogin = {};

  String _errorText = '';

  void _submit() async {
    // check
    final enteredUsername = _usernameController.text;
    final enteredPassword = _passwordController.text;

    _errorText = '';
    if (enteredUsername.isEmpty) {
      _errorText = 'Bạn chưa điền Tên đăng nhập';
    } else if (enteredPassword.isEmpty) {
      _errorText = 'Bạn chưa nhập Mật khẩu';
    } else if (enteredPassword.length < 6) {
      _errorText = 'Mật khẩu có ít nhất 6 ký tự';
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    if (accountToLogin.isEmpty) {
      accountToLogin = await dbProcess.queryAccount();
      // print(accountToLogin);
    }

    if (enteredUsername == accountToLogin['username'] &&
        enteredPassword == accountToLogin['password']) {
      await Future.delayed(
        const Duration(milliseconds: 400),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Đăng nhập thành công.',
              textAlign: TextAlign.center,
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            width: 300,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: const LibraryManagement(),
            duration: const Duration(milliseconds: 300),
          ),
          (route) => false,
        );
      }
    } else {
      _errorText = 'Tên đăng nhập hoặc mật khẩu không đúng';

      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Chào mừng đến với Reader',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(24),
        Container(
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
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
                'Tên đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _usernameController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'admin',
                  hintStyle: TextStyle(color: Color(0xFFACACAC)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  isCollapsed: true,
                ),
              ),
            ],
          ),
        ),
        const Gap(14),
        PasswordTextField(
          passwordController: _passwordController,
          onEditingComplete: _submit,
        ),
        const Gap(4),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
          child: Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: widget.onQuenMatKhauButtonClick,
              child: const Text('Quên mật khẩu'),
            ),
          ),
        ),
        const Gap(10),
        Text(
          _errorText,
          style: errorTextStyle(context),
        ),
        const Gap(12),
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
            : OutlinedButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  foregroundColor: Colors.black,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tiếp tục',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Gap(4),
                    Icon(Icons.login_rounded)
                  ],
                ),
              ),
        const Gap(40),
      ],
    );
  }
}
