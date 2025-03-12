import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../screens/inicio.dart'; // Importa la pantalla de inicio

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion>
    with SingleTickerProviderStateMixin {
  // --------------- VARIABLES GLOBALES -----------------
  late TextEditingController controladorEmail; // controlador para el campo de texto del email
  late TextEditingController controladorPass; // controlador para el campo de texto de la contraseña
  late bool ocultarPass; // variable booleana para cambiar el valor de obscuretext en el campo de texto de la contraseña
  late Icon iconoPass; // Icono de visibilidad de la contraseña

  // Método para inicializar las variables
  @override
  void initState() {
    controladorEmail = TextEditingController();
    controladorPass = TextEditingController();
    ocultarPass = true;
    iconoPass = const Icon(Icons.visibility);
    super.initState();
  }

  // Método asíncrono que devuelve un booleano para consultar los datos que introduce el usuario al iniciar sesión
  Future<bool> consultarInicioSesion() async {
    var url = Uri.parse(
        "http://localhost/mandangon/consultar_datos.php?email=${controladorEmail.text}&pass=${controladorPass.text}");

    if (kDebugMode) {
      print("URL de consulta: $url"); // Imprime la URL de consulta
    }

    http.Response consulta = await http.get(url);

    if (kDebugMode) {
      print("Código de estado de la respuesta: ${consulta.statusCode}"); // Imprime el código de estado
      print("Respuesta del servidor: ${consulta.body}"); // Imprime la respuesta del servidor
    }

    if (consulta.statusCode == 200) {
      final json = jsonEncode(consulta.body); // Convertimos en un json lo que devuelve el código php
      final respuesta = jsonDecode(json); // En una variable, decodificamos el json

      if (kDebugMode) {
        print("Respuesta decodificada: $respuesta"); // Imprime la respuesta decodificada
      }

      if (respuesta.toString().contains("true")) {
        if (kDebugMode) {
          print("Inicio de sesión exitoso"); // Imprime si el inicio de sesión fue exitoso
        }
        return true; // si la variable respuesta devuelve "true", devolveremos un true desde donde se ha llamado a este método
      } else {
        if (kDebugMode) {
          print("Inicio de sesión fallido: Credenciales incorrectas"); // Imprime si las credenciales son incorrectas
        }
        return false; // si la variable respuesta devuelve "false", devolveremos un false desde donde se ha llamado a este método
      }
    } else {
      if (kDebugMode) {
        print("Conexión fallida: ${consulta.statusCode}"); // Imprime si la conexión falló
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      El body lo hacemos en una columna para hacer un formulario y que todo esté centrado.
      Dentro de la columna hacemos una fila para cada elemento (imagen, campos de texto y botones).
      */
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IMAGEN LOGO
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ],
          ),
          // Campo de texto del email
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controladorEmail,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Campo de texto de la contraseña
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controladorPass,
                    obscureText: ocultarPass,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Contraseña",
                      suffixIcon: IconButton(
                        onPressed: () {
                          // Si presiona en el icono, cambiará el valor de la visibilidad de contraseña y el icono
                          setState(() {
                            if (ocultarPass) {
                              ocultarPass = false;
                              iconoPass = const Icon(Icons.visibility_off);
                            } else {
                              ocultarPass = true;
                              iconoPass = const Icon(Icons.visibility);
                            }
                          });
                        },
                        icon: iconoPass,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Botón del inicio de sesión
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    // Al presionar el botón, lo hacemos asíncrono para que se actualice el booleano que devuelve el método "consultarInicioSesion"
                    if (kDebugMode) {
                      print("Botón de inicio de sesión presionado"); // Imprime cuando se presiona el botón
                    }

                    if (await consultarInicioSesion() == false) {
                      // Si devuelve un false el método, mostrará un cuadro de diálogo
                      if (kDebugMode) {
                        print("Mostrando diálogo de error"); // Imprime antes de mostrar el diálogo
                      }

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
                      // Si devuelve un true el método, redirige a la pantalla de inicio
                      if (kDebugMode) {
                        print("Datos coincidentes"); // Imprime si las credenciales son correctas
                      }
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                            builder: (context) => PantallaPrincipal()), // Redirige a inicio.dart
                      );
                    }
                  },
                  label: const Text("Iniciar sesión"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}