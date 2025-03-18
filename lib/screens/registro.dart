import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandangon/metodos_lr/aniadir_usu.dart';
import 'package:mandangon/metodos_lr/validar_usu.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => RegistroEstado();
}

class RegistroEstado extends State<Registro> {
  final TextEditingController controladorNombreCompleto =
      TextEditingController();
  final TextEditingController controladorEmail = TextEditingController();
  final TextEditingController contrasenia = TextEditingController();
  final TextEditingController confirmarContrasenia = TextEditingController();
  final TextEditingController respuestaSeguridad = TextEditingController();

  String preguntaSeleccionada = 'mascota';

  bool ocultarPass = true;
  Icon iconoPass = const Icon(Icons.visibility);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/fondo1.png",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: const Image(image: AssetImage("assets/logo.png")),
                  ),
                  campoTexto(
                    controller: controladorNombreCompleto,
                    labelText: "Nombre Completo",
                    inputType: TextInputType.name,
                    formatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-ZÁ-ÿ ]"))
                    ],
                  ),
                  campoTexto(
                    controller: controladorEmail,
                    labelText: "Email",
                    inputType: TextInputType.emailAddress,
                  ),
                  campoTexto(
                    controller: contrasenia,
                    labelText: "Contraseña",
                    obscureText: ocultarPass,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          ocultarPass = !ocultarPass;
                          iconoPass = ocultarPass
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off);
                        });
                      },
                      icon: iconoPass,
                    ),
                  ),
                  campoTexto(
                    controller: confirmarContrasenia,
                    labelText: "Confirmar Contraseña",
                    obscureText: ocultarPass,
                  ),
                  // Campo para la pregunta de seguridad
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SizedBox(
                      width:
                          300, // Asegúrate de que esto es suficiente para tu diseño
                      child: Expanded(
                        // Usamos Expanded aquí
                        child: DropdownButtonFormField<String>(
                          value: preguntaSeleccionada,
                          items: const [
                            DropdownMenuItem(
                                value: 'mascota',
                                child: Text("¿Como se llama tu mascota?")),
                            DropdownMenuItem(
                                value: 'pelicula',
                                child: Text("¿Cuál es tu película favorita?")),
                            DropdownMenuItem(
                                value: 'famoso',
                                child: Text("¿Quién es tu famoso favorito?")),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              preguntaSeleccionada = newValue!;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFFFF7E1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFFAF1E6)),
                            ),
                            labelText: "Pregunta de seguridad",
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  campoTexto(
                    controller: respuestaSeguridad,
                    labelText: "Respuesta de seguridad",
                    inputType: TextInputType.text,
                    formatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z-ÿ]"))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Limpiar el nombre completo: eliminar espacios extra entre palabras
                        String nombreCompleto =
                            controladorNombreCompleto.text.trim();
                        nombreCompleto = nombreCompleto.replaceAll(
                            RegExp(r'\s+'),
                            ' '); // Reemplaza múltiples espacios con un solo espacio

                        // Validación de la respuesta de seguridad
                        String respuesta = respuestaSeguridad.text.trim();

                        // Aseguramos que la respuesta solo contiene letras
                        RegExp regex = RegExp(r'^[a-z-ÿ]+$');

                        if (!regex.hasMatch(respuesta)) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  const Text("Respuesta de seguridad inválida"),
                              content: const Text(
                                  "La respuesta solo puede contener letras y no debe tener espacios ni números."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Aceptar"),
                                ),
                              ],
                            ),
                          );
                          return; // No continúa si falla
                        }

                        if (!validarEmail(controladorEmail.text) ||
                            !validarPassword(
                                contrasenia.text, confirmarContrasenia.text)) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Datos Incorrectos"),
                              content: const Text(
                                "Asegúrate de escribir un email correcto y de que la contraseña contenga: una mayúscula, una minúscula, un número y mínimo 8 caracteres",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Aceptar"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          await AgregarUsuario.agregarUsuario(
                            context,
                            nombreCompleto, // Usar el nombre completo limpio
                            controladorEmail.text,
                            contrasenia.text,
                            preguntaSeleccionada,
                            respuestaSeguridad.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 80, 255, 220),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 5),
                      ),
                      child: const Text(
                        "Crear cuenta",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 18, 1, 66),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        width: 300,
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          inputFormatters: formatter,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFFFF7E1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Color(0xFFFAF1E6)),
            ),
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
