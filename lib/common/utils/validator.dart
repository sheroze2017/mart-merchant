class Validator {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    return emailRegex.hasMatch(email);
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a year';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'Please enter a valid year';
    }
    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) {
      return 'Please enter a year between 1900 and $currentYear';
    }
    return null;
  }

  static String? ValidEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    } else if (Validator.isValidEmail(email) == false) {
      return 'Invaild Email';
    } else {
      return null;
    }
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

  static String? validateCompany(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please enter company name';
    }
    return null;
  }

  static String? validateCity(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please enter location';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain one uppercase letter';
    } else if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain one lowercase letter';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }
}
