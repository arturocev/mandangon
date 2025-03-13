import 'package:flutter/material.dart';
import 'package:mandangon/screens/login.dart';
import 'package:mandangon/screens/registro.dart';

void main() {
  runApp(const MandangonApp());
}

class MandangonApp extends StatelessWidget {
  const MandangonApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MandangonApp',
      home: const MyHomePage(title: 'Login'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      El body lo hacemos en una columna para hacer un formulario y que todo esté centrado.
      Dentro de la columna hacemos una fila para cada elemento (imagen y botones).
      */
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // IMAGEN LOGO MANDANGON
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
            ],
          ),
          // Boton para ir a la pantalla de iniciar sesión
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IniciarSesion())); // Línea para navegar a la pantalla de inicio de sesión
                  },
                  label: Text("Iniciar sesión"),
                  heroTag: "btn1",
                ),
              ),
            ],
          ),
          // Boton para ir a la pantalla de registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Registro())); // Línea para navegar a la pantalla de registro
                  },
                  label: Text("Registrarse"),
                  heroTag: "btn2",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
