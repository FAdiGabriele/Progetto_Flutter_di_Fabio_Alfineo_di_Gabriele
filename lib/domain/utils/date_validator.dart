class DateValidator {
  static DateTime? getValidDateOrNull(String yearStr, String monthStr, String dayStr) {
    int? day = int.tryParse(dayStr);
    int? month = int.tryParse(monthStr);
    int? year = int.tryParse(yearStr);

    if (day == null || month == null || year == null) {
      return null;
    }

    if (year < 1 || year > 9999) {
      return null;
    }

    DateTime? parsedDate;
    try {
      parsedDate = DateTime(year, month, day);

      if (parsedDate.year != year ||
          parsedDate.month != month ||
          parsedDate.day != day) {
        return null;
      }
    } catch (e) {
      return null;
    }

    return DateTime(year, month, day);
  }

  static bool isFutureDate(DateTime dateToCheck) {
    return dateToCheck.isAfter(DateTime.now());
  }
}
