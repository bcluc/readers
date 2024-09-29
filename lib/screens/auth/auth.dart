import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/screens/auth/login_view.dart';
import 'package:readers/screens/auth/quen_mat_khau_view.dart';

class LoginLayout extends StatefulWidget {
  const LoginLayout({super.key});

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  final _pageController = PageController();
  double _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          MoveWindow(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.85, 1],
                ),
              ),
              position: DecorationPosition.foreground,
              child: Image.asset(
                'assets/book-cover/background-login.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            surfaceTintColor: Colors.transparent,
            elevation: 12,
            child: SizedBox(
              width: screenWidth * 0.61,
              // margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6, top: 6, right: 6),
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                          child: _pageIndex == 0
                              ? const SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    setState(() {
                                      _pageIndex = 0;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_back_rounded),
                                ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => appWindow.close(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Image.asset(
                    'assets/logo/Asset_1.png',
                    width: 44,
                  ),
                  const Gap(12),
                  SizedBox(
                    height: 380,
                    child: PageView(
                      controller: _pageController,
                      children: [
                        LoginView(
                          onQuenMatKhauButtonClick: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              _pageIndex = 1;
                            });
                          },
                        ),
                        QuenMatKhauView(
                          onBack: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              _pageIndex = 0;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
