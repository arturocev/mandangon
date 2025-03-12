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

Future<int?> consultarInicioSesion() async {
  var url = Uri.parse(
      "http://localhost/mandangon/consultar_datos.php?email=${controladorEmail.text}&pass=${controladorPass.text}");

  if (kDebugMode) {
    print("URL de consulta: $url");
  }

  http.Response consulta = await http.get(url);

  if (kDebugMode) {
    print("Código de estado de la respuesta: ${consulta.statusCode}");
    print("Respuesta del servidor: ${consulta.body}");
  }

  if (consulta.statusCode == 200) {
    try {
      // Intentamos decodificar la respuesta como JSON
      final respuesta = jsonDecode(consulta.body);

      if (respuesta['error'] == true) {
        // Si el campo 'error' es verdadero, mostramos el mensaje de error
        if (kDebugMode) {
          print("Error en la respuesta del servidor: ${respuesta['mensaje']}");
        }

        // Mostramos el mensaje de error en un cuadro de diálogo o en la UI
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Error de Inicio de Sesión"),
            content: Text(respuesta['mensaje']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );

        return null;  // Si hay un error (usuario no encontrado), devolvemos null.
      } else {
        // Si no hay error, obtenemos el ID del usuario
        final usuarioId = int.tryParse(respuesta['id'].toString());  // Convertimos la respuesta 'id' a entero.
        if (usuarioId != null) {
          return usuarioId;  // Devolvemos el ID como entero.
        } else {
          if (kDebugMode) {
            print("Error: El ID recibido no es un número válido.");
          }
          return null;  // Si no se puede convertir el ID a entero, devolvemos null.
        }
      }
    } catch (e) {
      // Si no podemos decodificar la respuesta como JSON, mostramos el error
      if (kDebugMode) {
        print("Error al procesar la respuesta: $e");
      }
      return null;  // Si hay un error al procesar la respuesta, devolvemos null.
    }
  } else {
    if (kDebugMode) {
      print("Conexión fallida: ${consulta.statusCode}");
    }
    return null;  // Si la conexión falla, devolvemos null.
  }
}

 
 
 
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  if (kDebugMode) {
    print("Botón de inicio de sesión presionado");
  }

  int? usuarioId = await consultarInicioSesion();

  if (usuarioId == null) {
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Datos Incorrectos"),
        content: const Text("Asegúrate de que el usuario ya esté registrado"),
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
        builder: (context) => PantallaPrincipal(usuarioId: usuarioId),  // Pasamos el usuarioId
      ),
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
