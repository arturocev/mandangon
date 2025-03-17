import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mandangon/screens/login.dart'; // Importa la pantalla de inicio

class RecuperarContrasena extends StatefulWidget {
  const RecuperarContrasena({super.key});

  @override
  State<RecuperarContrasena> createState() => RCEstado();
}

class RCEstado extends State<RecuperarContrasena> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController respuestaController = TextEditingController();

  String pregunta = "";
  int? userId;

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
        width: 300, // Tamaño más pequeño
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: formatter,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.orange[50], // Color de fondo del campo de texto
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Borde redondeado
            ),
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  Future<void> verificarCorreo() async {
    if (kDebugMode) {
      print("Enviando solicitud para verificar correo...");
    }
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/verificar_email.php'),
      body: {'email': emailController.text},
    );

    if (kDebugMode) {
      print("Respuesta status code: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("Respuesta body: ${response.body}");
    }

    try {
      var data = json.decode(response.body);
      if (kDebugMode) {
        print("Decodificado: $data");
      }

      if (data['status'] == 'ok') {
        setState(() {
          pregunta = data['pregunta'];
          userId = data['id_usu'];
        });
      } else {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Correo no encontrado"),
            content: const Text("No tenemos este correo registrado, por favor regístrate."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al decodificar JSON: $e");
      }
    }
  }

  Future<void> verificarRespuesta() async {
    if (kDebugMode) {
      print("Verificando respuesta...");
    }
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/verificar_respuesta.php'),
      body: {
        'id_usu': userId.toString(),
        'respuesta': respuestaController.text,
      },
    );

    if (kDebugMode) {
      print("Respuesta status code: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("Respuesta body: ${response.body}");
    }

    try {
      var data = json.decode(response.body);
      if (kDebugMode) {
        print("Decodificado: $data");
      }

      if (data['status'] == 'ok') {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("¡Contraseña restablecida!"),
            content: const Text("Hemos enviado un mensaje a tu correo con la nueva contraseña."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el dialog
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const IniciarSesion()),
                        ); // Navega al inicio
                },
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Respuesta incorrecta"),
            content: const Text("La respuesta no coincide. Inténtalo de nuevo."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al decodificar JSON: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.transparent, // Hacer la AppBar transparente
        elevation: 0, // Eliminar la sombra
        iconTheme: const IconThemeData(color: Colors.white), // Hacer que el ícono de atrás sea visible
      ),
      extendBodyBehindAppBar: true, // Asegurarse de que el contenido del body se muestre detrás de la AppBar
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo2.png'), // Cargar la imagen de fondo
            fit: BoxFit.cover, // Hacer que la imagen cubra toda la pantalla
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Campo de texto de email
                campoTexto(
                  controller: emailController,
                  labelText: "Correo electrónico",
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: verificarCorreo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 36, 230, 43),
                    foregroundColor: const Color.fromARGB(255, 10, 56, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Comprobar email"),
                ),
                if (pregunta.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Text(
                    pregunta == "mascota"
                        ? "¿Cómo se llama tu mascota?"
                        : pregunta == "pelicula"
                            ? "¿Cuál es tu película favorita?"
                            : "¿Quién es tu famoso favorito?",
                  ),
                  const SizedBox(height: 10),
                  // Campo de texto de respuesta
                  campoTexto(
                    controller: respuestaController,
                    labelText: "Respuesta",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: verificarRespuesta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 80, 255, 220),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                    ),
                    child: const Text(
                      "Confirmar respuesta",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 18, 1, 66),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
