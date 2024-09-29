import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/dto/tac_gia_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/extension.dart';

class TatCaSachCuaTacGia extends StatefulWidget {
  const TatCaSachCuaTacGia({
    super.key,
    required this.tacGia,
  });

  final TacGiaDto tacGia;

  @override
  State<TatCaSachCuaTacGia> createState() => _TatCaSachCuaTacGiaState();
}

class _TatCaSachCuaTacGiaState extends State<TatCaSachCuaTacGia> {
  late final List<String> _dauSachs;

  late final Future<void> _futureDauSachTacGias = _getDauSachTacGias();
  Future<void> _getDauSachTacGias() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _dauSachs =
        await dbProcess.queryDauSachWithMaTacGia(widget.tacGia.maTacGia);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Tên tác giả',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.tacGia.tenTacGia,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Gap(20),
              const Text(
                'Các cuốn sách',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: FutureBuilder(
                  future: _futureDauSachTacGias,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(
                          _dauSachs.length,
                          (index) => SizedBox(
                            width: double.infinity,
                            child: Text(
                              _dauSachs[index]
                                  .capitalizeFirstLetterOfEachWord(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Gap(20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                ),
                child: const Text('Đóng'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
