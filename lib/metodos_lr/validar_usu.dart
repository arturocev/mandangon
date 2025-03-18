final RegExp regexEmail = RegExp(r'^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
final RegExp regexPass = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");

bool validarEmail(String email) {
  return regexEmail.hasMatch(email);
}

bool validarPassword(String password, String confirmPassword) {
  // La contraseña debe tener al menos 8 caracteres, contener al menos una letra y un número,
  // y no permitir espacios
  if (password.length < 8 || !regexPass.hasMatch(password)) {
    return false;
  }
  return password == confirmPassword;
}
