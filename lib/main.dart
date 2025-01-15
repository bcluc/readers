import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readers/features/sach_management/cubit/sach_management_cubit.dart';
import 'package:readers/features/sach_management/data/sach_management_repository.dart';
import 'package:readers/features/sach_management/data/sach_management_service.dart';
import 'package:readers/features/tac_gia_management/cubit/tac_gia_management_cubit.dart';
import 'package:readers/features/tac_gia_management/data/tac_gia_management_repository.dart';
import 'package:readers/features/tac_gia_management/data/tac_gia_management_service.dart';
import 'package:readers/features/the_loai_management/cubit/the_loai_management_cubit.dart';
import 'package:readers/features/the_loai_management/data/the_loai_management_repository.dart';
import 'package:readers/features/the_loai_management/data/the_loai_management_service.dart';
import 'package:readers/screens/auth/auth.dart';
import 'package:readers/utils/db_process.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

DbProcess dbProcess = DbProcess();

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await dbProcess.connect();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SachManagementCubit(
            // Change SachManagementCubit to TatCaSachCubit
            SachManagementRepository(
              sachManagementService: SachManagementService(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => TacGiaManagementCubit(
            TacGiaManagementRepository(
              tacGiaManagementService: TacGiaManagementService(),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => TheLoaiManagementCubit(
            TheLoaiManagementRepository(
              theLoaiManagementService: TheLoaiManagementService(),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1280, 900);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Quản lý thư viện";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF48B8E9)),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoSansTextTheme(),
      ),
      home: const LoginLayout(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
      ],
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
    );
  }
}
