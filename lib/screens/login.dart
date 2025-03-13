import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../metodos_lr/inicio_sesion.dart';  // Importamos el archivo de servicios
import 'inicio.dart'; // Importa la pantalla de inicio

class IniciarSesion extends StatefulWidget {
  const IniciarSesion({super.key});

  @override
  State<IniciarSesion> createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion>
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
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.asset("assets/logo.png"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (kDebugMode) {
                      print("Botón de inicio de sesión presionado");
                    }

                    int? usuarioId = await inicioSesion(
                        controladorEmail.text, controladorPass.text, context);

                    if (usuarioId == null) {
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Datos Incorrectos"),
                          content:
                              const Text("Asegúrate de que el usuario ya esté registrado"),
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
                          builder: (context) => PantallaPrincipal(usuarioId: usuarioId),
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
