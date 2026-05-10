import '../constants/app_strings.dart';


class Validators {
  Validators._();

  
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.mobileRequired;
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return AppStrings.mobileDigitsOnly;
    }
    if (value.length != 10) {
      return AppStrings.mobileTenDigits;
    }
    return null;
  }

  
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.otpRequired;
    }
    if (value.length != 6) {
      return AppStrings.otpSixDigits;
    }
    return null;
  }

  
  static bool isMobileValid(String value) {
    return validateMobile(value) == null;
  }
}