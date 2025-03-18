import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../metodos_lr/inicio_sesion.dart';
import 'contrasena.dart';
import 'inicio.dart';

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => ISEstado();
}

class ISEstado extends State<IniciarSesion>
    with SingleTickerProviderStateMixin {
  late TextEditingController controladorEmail;
  late TextEditingController controladorPass;
  late bool ocultarPass;
  late Icon iconoPass;

  @override
  void initState() {
    controladorEmail = TextEditingController();
    controladorPass = TextEditingController();
    ocultarPass = true;
    iconoPass = const Icon(Icons.visibility);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extiende el cuerpo detrás de la AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              "assets/fondo1.png",
              fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
            ),
          ),
          // Contenido principal
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: const Image(image: AssetImage("assets/logo.png"),width: 300),
                  ),

                  // Campo de texto: Email
                  campoTexto(
                    controller: controladorEmail,
                    labelText: "Email",
                    inputType: TextInputType.emailAddress,
                  ),

                  // Campo de texto: Contraseña
                  campoTexto(
                    controller: controladorPass,
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

                  // Botón de Iniciar Sesión
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 36, 230, 43),
                        foregroundColor: const Color.fromARGB(255, 10, 56, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        if (kDebugMode) {
                          print("Botón de inicio de sesión presionado");
                        }

                        int? usuarioId = await inicioSesion(
                            controladorEmail.text,
                            controladorPass.text,
                            context);

                        if (usuarioId == null) {
                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Datos Incorrectos"),
                              content: const Text(
                                  "Asegúrate de que el usuario ya esté registrado"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Aceptar"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PantallaPrincipal(usuarioId: usuarioId),
                            ),
                          );
                        }
                      },
                      child: const Text("Iniciar sesión"),
                    ),
                  ),
                  // NUEVO BOTÓN para "¿Olvidaste la contraseña?"
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RecuperarContrasena()),
                        );
                      },
                      child: const Text(
                        "¿Olvidaste la contraseña?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 243, 33, 33), fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            fillColor: Colors.orange[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
