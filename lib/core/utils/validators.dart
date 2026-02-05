// ignore_for_file: deprecated_member_use

bool isValidEmail(String? email) {
  if (email == null || email.isEmpty) return false;
  final pattern =
      r"^[a-zA-Z0-9.!#%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
  final regExp = RegExp(pattern);
  return regExp.hasMatch(email.trim());
}

bool isValidPassword(String? password, {int minLength = 6}) {
  if (password == null) return false;
  return password.length >= minLength;
}
