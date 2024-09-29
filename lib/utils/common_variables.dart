import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

final myIconButtonStyle = IconButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  padding: const EdgeInsets.all(10),
);

TextStyle errorTextStyle(BuildContext context) => TextStyle(color: Theme.of(context).colorScheme.error);

Color getDataRowColor(BuildContext context, Set<MaterialState> states) {
  if (states.contains(MaterialState.selected)) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.3);
  }

  // Thứ tự các dòng if ở đây khá quan trọng, thay đổi thứ tự là thay đổi hành vi
  if (states.contains(MaterialState.pressed)) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.3);
  }
  if (states.contains(MaterialState.hovered)) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.1);
  }

  return Colors.transparent;
}
