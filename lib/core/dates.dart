extension DateTimeExtensions on DateTime {
  get weekOfYear {
    final startOfYear = DateTime(year, 1, 1);
    final firstMonday = startOfYear.weekday <= 4 ? startOfYear.subtract(Duration(days: startOfYear.weekday - 1)) : startOfYear.add(Duration(days: 8 - startOfYear.weekday));
    final diff = difference(firstMonday);
    return 1 + diff.inDays ~/ 7;
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
