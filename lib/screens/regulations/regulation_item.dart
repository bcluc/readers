import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:readers/main.dart';
import 'package:readers/utils/common_variables.dart';
import 'package:readers/utils/parameters.dart';

class RegulationItem extends StatefulWidget {
  const RegulationItem({
    super.key,
    required this.content,
    required this.regulation,
  });

  final String content;
  final String regulation;

  @override
  State<RegulationItem> createState() => _RegulationItemState();
}

class _RegulationItemState extends State<RegulationItem> {
  late final _controller = TextEditingController();
  bool _isHover = false;
  String _errorText = '';

  Future<void> _onSavedThamSo() async {
    _errorText = '';
    if (_controller.text.isEmpty) {
      setState(() {
        _errorText = 'Bạn chưa nhập giá trị cho tham số';
      });
      return;
    }

    if (int.tryParse(_controller.text) == null ||
        int.parse(_controller.text) < 0) {
      setState(() {
        _errorText = 'Giá trị phải là một con số lớn hơn 0';
      });
      return;
    }

    /* Cập nhật trong database */
    await dbProcess.updateGiaTriThamSo(
      thamSo: widget.regulation,
      giaTri: _controller.text,
    );

    /* Cập nhật trong app */
    ThamSoQuyDinh.setThamSo(
      widget.regulation,
      _controller.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật Tham số thành công.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 300,
        ),
      );
    }

    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return MouseRegion(
      onEnter: (event) => setState(
        () => _isHover = true,
      ),
      onHover: (_) => setState(
        () => _isHover = true,
      ),
      onExit: (_) => setState(
        () => _isHover = false,
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: _isHover ? Colors.grey.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.only(left: 30, top: 4, bottom: 4),
        child: Row(
          children: [
            /* SizedBox này có tác dụng quy định chiều cao của ROW */
            const SizedBox(
              height: 44,
            ),
            SizedBox(
              width: screenWidth * 0.5,
              child: Text(
                widget.content,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 120,
              child: Text(
                ThamSoQuyDinh.getThamSo(widget.regulation),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            SizedBox(
              width: 90,
              child: Text(
                '  ${ThamSoQuyDinh.getDonVi(widget.regulation)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const Gap(30),
            Expanded(
              child: Text(
                _errorText,
                style: errorTextStyle(context),
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(50),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 14,
                      ),
                      isCollapsed: true,
                    ),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onEditingComplete: _onSavedThamSo,
                  ),
                ),
                const Gap(8),
                IconButton(
                  onPressed: _onSavedThamSo,
                  icon: const Icon(Icons.save_rounded),
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
