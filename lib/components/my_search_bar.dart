import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText,
  });

  final TextEditingController controller;
  final String? hintText;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search),
              ),
              prefixIconColor: const Color.fromARGB(255, 81, 81, 81),
              hintText: hintText ?? 'Tìm kiếm',
              hintStyle: const TextStyle(
                color: Color.fromARGB(255, 81, 81, 81),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            ),
            onEditingComplete: () => onSearch(controller.text),
            /* 
              Khi gõ vào thanh tìm kiếm 1 chữ cái tiếng việt như từ ỏ
              thì value biến value sẽ lần lượt như sau:
              o -> rỗng -> ỏ
              nên khi value rỗng thì nó kích hoạt lệnh if (value.isEmpty)
              */
            onChanged: (value) async {
              if (value.isEmpty) {
                await Future.delayed(
                  const Duration(milliseconds: 50),
                );
                onSearch("");
              }
            },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        FilledButton(
          onPressed: () => onSearch(controller.text),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 38),
          ),
          child: const Icon(Icons.search),
        )
      ],
    );
  }
}
