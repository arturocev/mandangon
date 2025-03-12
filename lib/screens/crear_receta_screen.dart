import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class CrearRecetaScreen extends StatefulWidget {
  final Map<String, String>? receta;

  const CrearRecetaScreen({super.key, this.receta});

  @override
  CrearRecetaScreenState createState() => CrearRecetaScreenState();
}

class CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tituloController;
  late TextEditingController tipoController;
  late TextEditingController ingredientesController;
  late TextEditingController instruccionesController;
  late TextEditingController tiempoController;
  String? imagenPath;
  bool subiendo = false;

  @override
  void initState() {
    super.initState();
    tituloController =
        TextEditingController(text: widget.receta?['titulo'] ?? '');
    tipoController = TextEditingController(text: widget.receta?['tipo'] ?? '');
    ingredientesController =
        TextEditingController(text: widget.receta?['ingredientes'] ?? '');
    instruccionesController =
        TextEditingController(text: widget.receta?['instrucciones'] ?? '');
    tiempoController =
        TextEditingController(text: widget.receta?['tiempo'] ?? '');
    imagenPath = widget.receta?['imagen'];
  }

  @override
  void dispose() {
    tituloController.dispose();
    tipoController.dispose();
    ingredientesController.dispose();
    instruccionesController.dispose();
    tiempoController.dispose();
    super.dispose();
  }

  Future<void> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        imagenPath = imagen.path;
      });
    }
  }

  Widget mostrarImagen() {
    if (imagenPath == null || imagenPath!.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[700], size: 100),
      );
    }

    if (kIsWeb) {
      return Image.network(
        imagenPath!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagenPath!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  Future<void> guardarReceta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      subiendo = true;
    });

    String? imagenBase64;
    if (imagenPath != null && !kIsWeb) {
      List<int> imageBytes = await File(imagenPath!).readAsBytes();
      imagenBase64 = base64Encode(imageBytes);
    }

    var url = widget.receta == null
        ? Uri.parse(
            "http://localhost/guardar_receta.php") // Guardar nueva receta
        : Uri.parse(
            "http://localhost/actualizar_receta.php"); // Actualizar receta existente

    http.Response respuesta = await http.post(url, body: {
      'rec_id': widget.receta?['id_rec'] ?? '',
      'rec_nom': tituloController.text,
      'rec_tipo_com': tipoController.text,
      'rec_ing': ingredientesController.text,
      'rec_desc': instruccionesController.text,
      'rec_tmp': tiempoController.text,
      'rec_img': imagenBase64 ?? '',
      'rec_usu': 'usuario_demo'
    });

    if (!mounted) return;

    if (respuesta.statusCode == 200) {
      Map<String, String> recetaGuardada = {
        'id_rec': widget.receta?['id_rec'] ?? 'nuevo',
        'titulo': tituloController.text,
        'tipo': tipoController.text,
        'ingredientes': ingredientesController.text,
        'instrucciones': instruccionesController.text,
        'tiempo': tiempoController.text,
        'imagen': imagenPath ?? '',
      };

      Navigator.pop(context, recetaGuardada);
    } else {
      debugPrint("Error al guardar o actualizar la receta");
      // Mostrar error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar o actualizar la receta')),
      );
    }

    if (!mounted) return;
    setState(() {
      subiendo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta == null ? "Nueva Receta" : "Editar Receta"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mostrarImagen(),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: seleccionarImagen,
                    child: Text("Seleccionar Imagen"),
                  ),
                ),
                SizedBox(height: 20),
                _campoTexto(
                  label: "Título",
                  controller: tituloController,
                  hintText: "Ejemplo: Tarta de chocolate",
                ),
                SizedBox(height: 15),
                _campoTexto(
                  label: "Tipo de comida",
                  controller: tipoController,
                  hintText: "Ejemplo: Postre",
                ),
                SizedBox(height: 15),
                _campoTexto(
                  label: "Ingredientes",
                  controller: ingredientesController,
                  hintText: "Ejemplo: 2 huevos, 200g de harina...",
                  maxLines: 3,
                ),
                SizedBox(height: 15),
                _campoTexto(
                  label: "Instrucciones",
                  controller: instruccionesController,
                  hintText: "Escribe los pasos de la receta...",
                  maxLines: 5,
                ),
                SizedBox(height: 15),
                _campoTexto(
                  label: "Tiempo estimado (minutos)",
                  controller: tiempoController,
                  hintText: "Ejemplo: 30",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                Center(
                  child: subiendo
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: guardarReceta,
                          child: Text(widget.receta == null
                              ? 'Guardar Receta'
                              : 'Actualizar Receta'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto({
    required String label,
    required TextEditingController controller,
    required String hintText,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
          labelText: label, hintText: hintText, border: OutlineInputBorder()),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Este campo es obligatorio";
        }
        if ((label == "Título" || label == "Tipo de comida") &&
            !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return "Solo se permiten letras y espacios";
        }
        return null;
      },
    );
  }
}
