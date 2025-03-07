import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CrearRecetaScreen extends StatefulWidget {
  final Map<String, String>? receta;

  const CrearRecetaScreen({super.key, this.receta});

  @override
  _CrearRecetaScreenState createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  late TextEditingController tituloController;
  late TextEditingController tipoController;
  late TextEditingController ingredientesController;
  late TextEditingController instruccionesController;
  File? _imagen; 

  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.receta?['titulo'] ?? '');
    tipoController = TextEditingController(text: widget.receta?['tipo'] ?? '');
    ingredientesController = TextEditingController(text: widget.receta?['ingredientes'] ?? '');
    instruccionesController = TextEditingController(text: widget.receta?['instrucciones'] ?? '');
    
    if (widget.receta != null && widget.receta!['imagen'] != null) {
      _imagen = File(widget.receta!['imagen']!);
    }
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagenSeleccionada = await picker.pickImage(source: ImageSource.gallery);

    if (imagenSeleccionada != null) {
      setState(() {
        _imagen = File(imagenSeleccionada.path);
      });
    }
  }

  void _guardarReceta() {
    if (tituloController.text.isEmpty ||
        tipoController.text.isEmpty ||
        ingredientesController.text.isEmpty ||
        instruccionesController.text.isEmpty ||
        _imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Todos los campos son obligatorios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nuevaReceta = {
      'titulo': tituloController.text,
      'tipo': tipoController.text,
      'ingredientes': ingredientesController.text,
      'instrucciones': instruccionesController.text,
      'imagen': _imagen!.path,
    };

    Navigator.pop(context, nuevaReceta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receta == null ? 'Crear Receta' : 'Editar Receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título", style: TextStyle(fontSize: 18)),
            TextField(
              controller: tituloController,
              decoration: InputDecoration(hintText: "Ejemplo: Tarta de chocolate"),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
            ),
            SizedBox(height: 16),
            Text("Tipo de Comida", style: TextStyle(fontSize: 18)),
            TextField(
              controller: tipoController,
              decoration: InputDecoration(hintText: "Ejemplo: Postre"),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))],
            ),
            SizedBox(height: 16),
            Text("Ingredientes", style: TextStyle(fontSize: 18)),
            TextField(
              controller: ingredientesController,
              maxLines: 5,
              decoration: InputDecoration(hintText: "Ejemplo: 2 huevos, 200g de harina..."),
            ),
            SizedBox(height: 16),
            Text("Instrucciones", style: TextStyle(fontSize: 18)),
            TextField(
              controller: instruccionesController,
              maxLines: 6,
              decoration: InputDecoration(hintText: "Escribe los pasos de la receta..."),
            ),
            SizedBox(height: 16),
            Text("Imagen de la Receta", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  _imagen != null
                      ? Image.file(_imagen!, height: 150, width: 150, fit: BoxFit.cover)
                      : Container(
                          height: 150,
                          width: 150,
                          color: Colors.grey[300],
                          child: Icon(Icons.image, size: 50, color: Colors.grey[700]),
                        ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _seleccionarImagen,
                    child: Text("Seleccionar Imagen"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _guardarReceta,
                child: Text(widget.receta == null ? 'Guardar Receta' : 'Actualizar Receta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}