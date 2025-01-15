import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/features/the_loai_management/dtos/the_loai_dto.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/extension.dart';

class TatCaSachThuocTheLoai extends StatefulWidget {
  const TatCaSachThuocTheLoai({
    super.key,
    required this.theLoai,
  });

  final TheLoaiDto theLoai;

  @override
  State<TatCaSachThuocTheLoai> createState() => _TatCaSachThuocTheLoaiState();
}

class _TatCaSachThuocTheLoaiState extends State<TatCaSachThuocTheLoai> {
  late final List<String> _dauSachs;

  late final Future<void> _futureDauSachTheLoais = _getDauSachTheLoais();
  Future<void> _getDauSachTheLoais() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _dauSachs =
        await dbProcess.queryDauSachWithMaTheLoai(widget.theLoai.maTheLoai);
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
                'Tên thể loại',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.theLoai.tenTheLoai,
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
                  future: _futureDauSachTheLoais,
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
