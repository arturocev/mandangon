final RegExp regexEmail = RegExp(r'^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp regexPass = RegExp(r"([A-Za-z]+[A-Za-z]+[0-9]+)");

bool validarEmail(String email) {
  return regexEmail.hasMatch(email);
}

bool validarPassword(String password, String confirmPassword) {
  if (password.length < 8 || !regexPass.hasMatch(password)) {
    return false;
  }
  return password == confirmPassword;
}
