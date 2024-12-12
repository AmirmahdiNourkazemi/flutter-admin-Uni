import 'package:persian_number_utility/persian_number_utility.dart';

String? validationNationalCode(String? value) {
  RegExp nationalCodePattern = RegExp(r'^\d{10}$');
  if (value!.isEmpty) {
    return 'کد ملی خود را وارد کنید';
  } else if (nationalCodePattern.hasMatch(value) == false) {
    return 'کد ملی درست نمیباشد';
  }
}

String? validationbileNumber(String? value) {
  RegExp mobileNumberCodePattern = RegExp(r'^\d{11}$');
  if (value!.isEmpty) {
    return 'شماره موبایل را وارد کنید';
  }
  if (value.isValidIranianMobileNumber() == false) {
    return 'شماره موبایل اشتباه است';
  }
  if (mobileNumberCodePattern.hasMatch(value) == false) {
    return 'شماره موبایل اشتباه است';
  }
}
