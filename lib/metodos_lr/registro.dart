import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mandangon/main.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  // ----------------- VARIABLES GLOBALES -----------------------

  // --------- CONTROLADORES DE TEXTO --------------
  late TextEditingController controladorNombreCompleto;
  late TextEditingController controladorEmail;
  late TextEditingController contrasenia;
  late TextEditingController confirmarContrasenia;

  // -------- Variables de los patrones de la contraseña y el email ---------------
  late String patronEmail;
  late String patronPass;

  // -------- Variables de expresiones regulares del email y contraseña. RegExp te permite introducir un patrón
  late RegExp regexEmail;
  late RegExp regexPass;

  // -------- Variables boleanas del email y contraseña
  late bool esValidoEmail;
  late bool esValidoPass;
  late bool ocultarPass; // variable booleana para cambiar el valor de obscuretext en el campo de texto de la contraseña
  late Icon iconoPass; // Icono de visibilidad de la contraseña

  // -------- Método para inicializar las variables
  @override
  void initState() {
    controladorNombreCompleto = TextEditingController();
    controladorEmail = TextEditingController();
    contrasenia = TextEditingController();
    confirmarContrasenia = TextEditingController();
    ocultarPass = true;
    iconoPass = const Icon(Icons.visibility);
    esValidoEmail = false;
    esValidoPass = false;

    patronEmail = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

    patronPass = r"([A-Z]+[a-z]+[0-9]+)";

    regexPass = RegExp(patronPass); // Variable que tiene de patrón la variable "patronPass"
    regexEmail = RegExp(patronEmail); // Variable que tiene de patrón la variable "patronEmail"
    super.initState();
  }

  // Método que al pulsar el botón de crear cuenta comprueba si el email es válido o no y devuelve un boleano
  bool validarEmail(String email) {
    if (!regexEmail.hasMatch(email)) {
      if (kDebugMode) {
        print("Email no válido: $email"); // Imprime si el email no es válido
      }
      return false; // Si el patrón no coincide, devuelve un false
    } else {
      if (kDebugMode) {
        print("Email válido: $email"); // Imprime si el email es válido
      }
      return true; // Si el patrón coincide, devuelve un true
    }
  }

  // Método que al pulsar el botón de crear cuenta comprueba si la contraseña es válida o no y devuelve un boleano
  bool validarPassword() {
    if (contrasenia.text.length < 8) {
      if (kDebugMode) {
        print("Contraseña no válida: Longitud menor a 8 caracteres"); // Imprime si la contraseña es demasiado corta
      }
      return false; // Si la longitud de la contraseña es menor que 8, devuelve un false
    } else if (!regexPass.hasMatch(contrasenia.text)) {
      if (kDebugMode) {
        print("Contraseña no válida: No cumple con el patrón requerido"); // Imprime si la contraseña no cumple con el patrón
      }
      return false; // Si el patrón no coincide, devuelve un false
    }

    if (confirmarContrasenia.text != contrasenia.text) {
      if (kDebugMode) {
        print("Contraseñas no coinciden"); // Imprime si las contraseñas no coinciden
      }
      return false; // si confirmarContrasenia no es igual que contrasenia, devuelve un false
    } else {
      if (kDebugMode) {
        print("Contraseña válida"); // Imprime si la contraseña es válida
      }
      return true; // si las contraseñas son iguales, devuelve un true
    }
  }

Future<void> agregarUsuario() async {
  var url = Uri.parse("http://localhost/mandangon/insertar_datos.php");

  if (kDebugMode) {
    print("URL de inserción: $url");
    print("Datos a enviar: nombre=${controladorNombreCompleto.text}, email=${controladorEmail.text}, contraseña=${contrasenia.text}");
  }

  try {
    // Mostrar un indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario cierre el diálogo
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(), // Indicador de carga
        );
      },
    );

    // Realizar la solicitud HTTP
    http.Response respuesta = await http.post(url, body: {
      "nombre": controladorNombreCompleto.text,
      "contrasenia": contrasenia.text,
      "email": controladorEmail.text,
    });

    // Cerrar el indicador de carga
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if (respuesta.statusCode == 200) {
      if (kDebugMode) {
        print("Conexión exitosa");
        print("Respuesta del servidor: ${respuesta.body}");
      }
      // Mostrar un mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cuenta creada exitosamente")),
      );

      // Redirigir a la pantalla main.dart
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => MandangonApp()), // Reemplaza "Main" con el nombre de tu pantalla principal
      );
    } else {
      if (kDebugMode) {
        print("Conexión fallida: ${respuesta.statusCode}");
        print("Respuesta del servidor: ${respuesta.body}");
      }
      // Mostrar un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear la cuenta")),
      );
    }
  } catch (e) {
    // Cerrar el indicador de carga en caso de error
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    if (kDebugMode) {
      print("Error en la solicitud: $e");
    }
    // Mostrar un mensaje de error
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error de conexión")),
    );
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
          // Campo de texto de nombre completo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    controller: controladorNombreCompleto,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nombre Completo",
                    ),
                  ),
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
                    keyboardType: TextInputType.emailAddress,
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
                    controller: contrasenia,
                    maxLength: 12,
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
          // Campo de texto de confirmación de contraseña
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: confirmarContrasenia,
                    obscureText: ocultarPass,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Confirmar contraseña",
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
          // Botón para crear la cuenta
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (!validarEmail(controladorEmail.text) || !validarPassword()) {
                      if (kDebugMode) {
                        print("Mostrando diálogo de error");
                      }
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Datos Incorrectos"),
                          content: const Text(
                              "Asegúrate de escribir un email correcto y de que la contraseña contenga: una mayúscula, una minúscula, un número y mínimo 8 caracteres"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Aceptar"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (kDebugMode) {
                        print("Datos válidos, llamando a agregarUsuario");
                      }
                      await agregarUsuario(); // Usar await para esperar a que la operación termine
                    }
                  },
                  label: const Text("Crear cuenta"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}