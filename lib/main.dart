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
      theme: ThemeData(
        // Definir una paleta de colores cálidos
        scaffoldBackgroundColor: Color(0xFFF9E4B7), // Fondo color crema cálido
        primaryColor:
            Color.fromARGB(255, 145, 215, 118), // Verde suave para botones
        hintColor: Color.fromARGB(255, 115, 226, 93), // Azul suave para botones
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontFamily: 'Roboto', fontSize: 16, color: Colors.black),
        ),
      ),
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
                padding: const EdgeInsets.only(
                    bottom: 40), // Aumenta el margen de abajo
                child: const Image(image: AssetImage("assets/logo.png")),
              ),
            ],
          ),
          // Botón para ir a la pantalla de iniciar sesión
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IniciarSesion())); // Línea para navegar a la pantalla de inicio de sesión
                  },
                  label: Text(
                    "Iniciar sesión",
                    style: TextStyle(color: Color.fromARGB(255, 10, 56, 1), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor:
                      Color.fromARGB(255, 36, 230, 43), // Verde suave
                  heroTag: "btn1",
                ),
              ),
            ],
          ),
          // Botón para ir a la pantalla de registro
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Registro())); // Línea para navegar a la pantalla de registro
                  },
                  label: Text(
                    "Registrarse",
                    style: TextStyle(color: Color.fromARGB(255, 18, 1, 66), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Color.fromARGB(255, 80, 255, 220), // Azul suave
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
