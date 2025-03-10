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
  
  late TextEditingController controladorEmail;
  late TextEditingController controladorPass;
  late bool inicioSesion;

  void initState() {
    controladorEmail = TextEditingController();
    controladorPass = TextEditingController();
    inicioSesion = false;
    super.initState();
  }
   
  void consultarInicioSesion() async {

    var url = Uri.parse("http://localhost/consultar_datos.php?email=${controladorEmail.text}&pass=${controladorPass.text}");

    http.Response consulta = await http.get(url);
    if (consulta.statusCode == 200) {
      final json = jsonEncode(consulta.body);
      final respuesta = jsonDecode(json);
      if (respuesta.toString().contains("true")) {
        inicioSesion = true;
      } else {
        inicioSesion = false;
      }
      
    } else {
      print("Conexión fallida");
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
          // Botón del inicio de sesión
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: 
                    FloatingActionButton.extended(
                      onPressed: () {
                        consultarInicioSesion();
                        print(inicioSesion);
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