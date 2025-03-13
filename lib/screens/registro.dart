import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandangon/metodos_lr/aniadir_usu.dart';
import 'package:mandangon/metodos_lr/validar_usu.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => RegistroEstado();
}

class RegistroEstado extends State<Registro> {
  final TextEditingController controladorNombreCompleto =
      TextEditingController();
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController contrasenia = TextEditingController();
  final TextEditingController confirmarContrasenia = TextEditingController();

  bool ocultarPass = true;
  Icon iconoPass = const Icon(Icons.visibility);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(  // Esto asegura que todo el contenido esté centrado
        child: SingleChildScrollView(  // Para permitir el desplazamiento en pantallas pequeñas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage("assets/logo.png")),

              // Campo de texto: Nombre Completo
              campoTexto(
                controller: controladorNombreCompleto,
                labelText: "Nombre Completo",
                inputType: TextInputType.name,
                formatter: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-ZÁ-ÿ ]"))
                ],
              ),

              // Campo de texto: Email
              campoTexto(
                controller: controladorEmail,
                labelText: "Email",
                inputType: TextInputType.emailAddress,
              ),

              // Campo de texto: Contraseña
              campoTexto(
                controller: contrasenia,
                labelText: "Contraseña",
                obscureText: ocultarPass,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      ocultarPass = !ocultarPass;
                      iconoPass = ocultarPass
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off);
                    });
                  },
                  icon: iconoPass,
                ),
              ),

              // Campo de texto: Confirmar Contraseña
              campoTexto(
                controller: confirmarContrasenia,
                labelText: "Confirmar Contraseña",
                obscureText: ocultarPass,
              ),

              // Botón de registro
              FloatingActionButton.extended(
                onPressed: () async {
                  if (!validarEmail(controladorEmail.text) ||
                      !validarPassword(
                          contrasenia.text, confirmarContrasenia.text)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Datos Incorrectos"),
                        content: const Text(
                          "Asegúrate de escribir un email correcto y de que la contraseña contenga: una mayúscula, una minúscula, un número y mínimo 8 caracteres",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Aceptar"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await AgregarUsuario.agregarUsuario(
                      context,
                      controladorNombreCompleto.text,
                      controladorEmail.text,
                      contrasenia.text,
                    );
                  }
                },
                label: const Text("Crear cuenta"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los campos de texto
  Widget campoTexto({
    required TextEditingController controller,
    required String labelText,
    TextInputType? inputType,
    List<TextInputFormatter>? formatter,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: formatter,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
