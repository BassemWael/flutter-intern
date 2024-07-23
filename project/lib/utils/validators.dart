String? emailSignupValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email must not be empty';
  }
  String pattern = r'^[^@]+@[^@]+\.[^@]+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Email must be in the format example@example.com';
  }
  return null;
}

String? passwordSignupValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password must not be empty';
  }
  if (value.length <= 6) {
    return 'Password must be more than 6 characters';
  }
  return null;
}

String? userNameSignupValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name must not be empty';
  }
  return null;
}

