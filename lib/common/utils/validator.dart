class Validator {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    final RegExp phoneNumberRegExp = RegExp(r'^[0-9]+$');
    if (!phoneNumberRegExp.hasMatch(value)) {
      return 'Phone number can only contain digits';
    }

    if (value.length != 11) {
      return 'Please enter a valid 11-digit phone number';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegExp.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }
}
