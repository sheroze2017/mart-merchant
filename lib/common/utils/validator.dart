class Validator {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
    );
    return emailRegex.hasMatch(email);
  }
}
