class PasswordValidator {
  static String? validatePassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );

    if (!passwordRegExp.hasMatch(password)) {
      return 'Password must be 8+ characters long, with upper, lower, number, and special character.';
    }
    return null;
  }
}
