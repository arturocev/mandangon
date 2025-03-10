import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

  // -------- Método para inicializar las variables

  @override
  void initState() {
    controladorNombreCompleto = TextEditingController();
    controladorEmail = TextEditingController();
    contrasenia = TextEditingController();
    confirmarContrasenia = TextEditingController();
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
      return false; // Si el patrón no coincide, devuelve un false
    } else {
      return true; // Si el patrón coincide, devuelve un true
    }
  }


  // Método que al pulsar el botón de crear cuenta comprueba si la contraseña es válida o no y devuelve un boleano
  bool validarPassword() {
    if (contrasenia.text.length < 8) 
    {
      return false; // Si la longitud de la contraseña es menor que 8, devuelve un false
    }
    else if (!regexPass.hasMatch(contrasenia.text)) {
      return false; // Si el patrón no coincide, devuelve un false
    }

    if (confirmarContrasenia.text != contrasenia.text) {
      return false; // si confirmarContrasenia no es igual que contrasenia, devuelve un false
    } else {
      return true; // si las contraseñas son iguales, devuelve un true
    }
  }

  // Método asíncrono que realizamos para insertar los datos del usuario a la base de datos
  void agregarUsuario() async {
    var url = Uri.parse("http://localhost/insertar_datos.php"); // Aquí insertamos en una variable la url donde se encuentra el archivo .php

    // Llamamos a la url y le pasamos al archivo .php los parámetros de nombre, contrasenia y email
    http.Response respuesta = await http.post(url, body: {
      "nombre": controladorNombreCompleto.text,
      "contrasenia": contrasenia.text,
      "email": controladorEmail.text
    });
    if (respuesta.statusCode == 200) {
      print("Conexion exitosa"); // Si todo ha ido bien, se meterá aquí
    } else {
      print("Conexión fallida"); // Si algo ha ido mal, se meterá aquí
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
              Padding(padding: EdgeInsets.only(bottom: 20),
              child: Image(
                image: AssetImage("assets/images/logo.png"),
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
                padding: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    inputFormatters: [
                       FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    controller: controladorNombreCompleto,
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controladorEmail,
                    keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
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
                padding: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: contrasenia,
                    maxLength: 12,
                    obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contraseña",
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
                padding: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    controller: confirmarContrasenia,
                    obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirmar contraseña",
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
                  padding: EdgeInsets.only(bottom: 20),
                  child: 
                    FloatingActionButton.extended(
                      // si validarEmail devuelve un false o validarPassword devuelve un false, se ejecutará un showDialog
                      onPressed: () => !validarEmail(controladorEmail.text) || !validarPassword() ? showDialog(
                        context: context, 
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Datos Incorrectos"),
                          content: Text("Aseguráte de escribir un email correcto y de que la contraseña contenga: una mayúscula, una minúscula, un número y mínimo 8 caracteres"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: Text("Aceptar"),
                              )
                          ],
                        )
                      ) : agregarUsuario(), // si validarEmail y validarPassword devuelven un true, se ejecutará la función agregarUsuario
                      label: Text("Crear cuenta"),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}