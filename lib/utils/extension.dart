import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toVnFormat() {
    return '${day.twoDigits()}/${month.twoDigits()}/${year.twoDigits()}';
  }
}

extension IntExtension on int {
  String toVnCurrencyFormat() {
    return NumberFormat.currency(locale: 'vi_VN').format(this);
  }

  String toVnCurrencyWithoutSymbolFormat() {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '').format(this).trim();
  }

  String twoDigits() {
    if (this >= 10) return "$this";
    return "0$this";
  }
}

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }

  /* Dùng để format họ tên */
  String capitalizeFirstLetterOfEachWord() {
    trim();
    List<String> words = split(" ");
    for (int i = 0; i < words.length; i++) {
      words[i] = words[i][0].toUpperCase() + words[i].substring(1);
    }
    return words.join(" ");
  }
}

extension DateTimeExtension on DateTime {
  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 9999);
  }
}
