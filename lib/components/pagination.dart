import 'package:flutter/material.dart';
import 'package:readers/utils/common_variables.dart';

class Pagination extends StatefulWidget {
  const Pagination({
    super.key,
    required this.controller,
    required this.maxPages,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int maxPages;
  final void Function(int) onChanged;

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  @override
  Widget build(BuildContext context) {
    int currentPage = int.parse(widget.controller.text);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton.filled(
          onPressed: () {
            if (currentPage == 1) {
              return;
            }
            setState(() {
              currentPage--;
              widget.controller.text = currentPage.toString();
            });
            widget.onChanged(currentPage);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          style: myIconButtonStyle,
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 44,
                child: TextField(
                  controller: widget.controller,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(1, 8, 0, 8),
                    isCollapsed: true,
                  ),
                  onEditingComplete: () {
                    int? inputPage = int.tryParse(widget.controller.text);
                    if (inputPage != null &&
                        1 <= inputPage &&
                        inputPage <= widget.maxPages) {
                      widget.onChanged(inputPage);
                    } else {
                      widget.controller.text = currentPage.toString();
                    }
                  },
                ),
              ),
              Text(
                '   /  ${widget.maxPages}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 5)
            ],
          ),
        ),
        const SizedBox(width: 4),
        IconButton.filled(
          onPressed: () {
            if (currentPage == widget.maxPages) {
              return;
            }

            setState(() {
              currentPage++;
              widget.controller.text = currentPage.toString();
            });

            widget.onChanged(currentPage);
          },
          icon: const Icon(Icons.arrow_forward_ios_rounded),
          style: myIconButtonStyle,
        ),
      ],
    );
  }
}
