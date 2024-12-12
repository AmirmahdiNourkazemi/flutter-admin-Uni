import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shamsi_date/shamsi_date.dart' as jal;

String jalili2Gorgian(String jalili) {
  List date = jalili.toEnglishDigit().split('/');

  jal.Jalali j =
      jal.Jalali(int.parse(date[0]), int.parse(date[1]), int.parse(date[2]));
  jal.Gregorian gregorian = j.toGregorian();
  return '${gregorian.year}-${gregorian.month}-${gregorian.day}';
}
