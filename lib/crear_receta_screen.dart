import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class CrearRecetaScreen extends StatefulWidget {
  final Map<String, String>? receta;

  const CrearRecetaScreen({Key? key, this.receta}) : super(key: key);

  @override
  _CrearRecetaScreenState createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController tituloController;
  late TextEditingController tipoController;
  late TextEditingController ingredientesController;
  late TextEditingController instruccionesController;
  String? imagenPath;

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
    imagenPath = widget.receta?['imagen'];
  }

  @override
  void dispose() {
    tituloController.dispose();
    tipoController.dispose();
    ingredientesController.dispose();
    instruccionesController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        imagenPath = imagen.path;
      });
    }
  }

  Widget _mostrarImagen() {
    if (imagenPath == null || imagenPath!.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[700], size: 100),
      );
    }

    if (kIsWeb) {
      return Image.network(imagenPath!,
          width: double.infinity, height: 200, fit: BoxFit.cover);
    } else {
      return Image.file(File(imagenPath!),
          width: double.infinity, height: 200, fit: BoxFit.cover);
    }
  }

  void _guardarReceta() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'titulo': tituloController.text,
        'tipo': tipoController.text,
        'ingredientes': ingredientesController.text,
        'instrucciones': instruccionesController.text,
        'imagen': imagenPath ?? '',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.receta == null ? "Nueva Receta" : "Editar Receta")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _mostrarImagen(),
                SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _seleccionarImagen,
                    child: Text("Seleccionar Imagen"),
                  ),
                ),
                SizedBox(height: 20),
                _campoTexto("Título", tituloController),
                TextField(
                  controller: tituloController,
                  decoration:
                      InputDecoration(hintText: "Ejemplo: Tarta de chocolate"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
                ),
                SizedBox(height: 15),
                _campoTexto("Tipo de comida", tipoController),
                TextField(
                  controller: tipoController,
                  decoration: InputDecoration(hintText: "Ejemplo: Postre"),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
                ),
                SizedBox(height: 15),
                _campoTexto("Ingredientes", ingredientesController,
                    maxLines: 6),
                TextField(
                  controller: ingredientesController,
                  decoration: InputDecoration(
                      hintText: "Ejemplo: 2 huevos, 200 g de harina..."),
                ),
                SizedBox(height: 15),
                _campoTexto("Instrucciones", instruccionesController,
                    maxLines: 6),
                TextField(
                  controller: instruccionesController,
                  decoration: InputDecoration(
                      hintText: "Ejemplo: Escribe los pasos para la receta..."),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _guardarReceta,
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

  Widget _campoTexto(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }
}
