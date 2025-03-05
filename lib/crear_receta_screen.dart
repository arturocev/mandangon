import 'package:flutter/material.dart';

class CrearRecetaScreen extends StatefulWidget {
  @override
  _CrearRecetaScreenState createState() => _CrearRecetaScreenState();
}

class _CrearRecetaScreenState extends State<CrearRecetaScreen> {
  final _tituloController = TextEditingController();
  final _tipoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _ingredientesController = TextEditingController();

  void _guardarReceta() {
    if (_tituloController.text.isNotEmpty &&
        _tipoController.text.isNotEmpty &&
        _descripcionController.text.isNotEmpty &&
        _ingredientesController.text.isNotEmpty) {
      Navigator.pop(context, {
        'titulo': _tituloController.text,
        'tipo': _tipoController.text,
        'descripcion': _descripcionController.text,
        'ingredientes': _ingredientesController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todos los campos son obligatorios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir Receta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _tipoController,
              decoration: InputDecoration(labelText: 'Tipo de comida'),
            ),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripciones'),
            ),
            TextField(
              controller: _ingredientesController,
              decoration: InputDecoration(labelText: 'Ingredientes'),
              maxLines: 3,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _guardarReceta,
              child: Text('Guardar receta'),
            ),
          ],
        ),
      ),
    );
  }
}
