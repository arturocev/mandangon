import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

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
  void initState() {
    controladorEmail = TextEditingController();
    controladorPass = TextEditingController();
    ocultarPass = true;
    iconoPass = Icon(Icons.visibility);
    super.initState();
  }
  
  // Método asíncrono que devuelve un booleano para consultar los datos que introduce el usuario al iniciar sesión
  Future<bool> consultarInicioSesion() async {

    var url = Uri.parse("http://localhost/consultar_datos.php?email=${controladorEmail.text}&pass=${controladorPass.text}");

    http.Response consulta = await http.get(url);
    if (consulta.statusCode == 200) {
      final json = jsonEncode(consulta.body); //Convertimos en un json lo que devuelve el código php
      final respuesta = jsonDecode(json); // En una variable, decodificamos el json
      if (respuesta.toString().contains("true")) {
        return true; // si la variable respuesta devuelve "true", devolveremos un true desde donde se ha llamado a este método
      } else {
        return false; // si la variable respuesta devuelve "false", devolveremos un false desde donde se ha llamado a este método
      }
    } else {
      print("Conexión fallida");
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
              Padding(padding: EdgeInsets.only(bottom: 20),
              child: Image(
                image: AssetImage("assets/images/logo.png"),
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
                    controller: controladorPass,
                    obscureText: ocultarPass,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contraseña",
                    suffixIcon: IconButton(onPressed: () { // Si presiona en el icono, cambiará el valor de la visibilidad de contraseña y el icono
                      setState(() {
                        if (ocultarPass) {
                          ocultarPass = false;
                          iconoPass = Icon(Icons.visibility_off);
                        } else {
                          ocultarPass = true;
                          iconoPass = Icon(Icons.visibility);
                        } 
                      });
                    }, icon: iconoPass
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
                  padding: EdgeInsets.only(bottom: 20),
                  child: 
                    FloatingActionButton.extended(
                      onPressed: () async { // Al presionar el botón, lo hacemos asíncrono para que se actualice el booleano que devuelve el método "consultarInicioSesion"
                        if (await consultarInicioSesion() == false) { // Si devuelve un false el método, mostrará un cuadro de diálogo
                            showDialog(
                            context: context, 
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("Datos Incorrectos"),
                              content: Text("Asegúrate de que el usuario ya esté registrado"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context), 
                                  child: Text("Aceptar"),
                                  )
                              ],
                            )
                          );
                        } else { // Si devuelve un true el método, mostrará este print
                          print("Datos coincidentes");
                        }
                      }, 
                      label: Text("Iniciar sesión"),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}