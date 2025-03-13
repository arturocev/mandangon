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
      appBar: AppBar(
        backgroundColor: Color(0xFFF9E4B7), // Color cálido para la AppBar
        title: const Text('Registro', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: Center(
        // Centra todo el contenido en la pantalla
        child: SingleChildScrollView(
          // Para permitir desplazamiento en pantallas pequeñas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 40), // Aumenta el margen de abajo
                child: const Image(image: AssetImage("assets/logo.png")),
              ),
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

              // Botón de registro con diseño mejorado
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 80, 255, 220), // Azul suave
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    "Crear cuenta",
                    style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 18, 1, 66), fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para los campos de texto con diseño mejorado
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
            filled: true,
            fillColor: Color(0xFFFFF7E1), // Fondo crema suave para los campos
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
              borderSide: BorderSide(color: Color(0xFFFAF1E6)),
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
