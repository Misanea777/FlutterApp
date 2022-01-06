extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension EmailValidatorWithErr on String? {
  String? isValidEmailWithErrCode() {
    return this!.isEmpty ? 'Email cannot be empty' :
      (!this!.isValidEmail()) ? 'Email is invalid' : null;
  }
}

extension StringExtension on String {
  String cutAllBefore(String marker) {
    return substring(indexOf(marker)+1);
  }
}

