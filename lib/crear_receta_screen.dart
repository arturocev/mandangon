import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    super.initState();
    tituloController = TextEditingController(text: widget.receta?['titulo'] ?? '');
    tipoController = TextEditingController(text: widget.receta?['tipo'] ?? '');
    ingredientesController = TextEditingController(text: widget.receta?['ingredientes'] ?? '');
    instruccionesController = TextEditingController(text: widget.receta?['instrucciones'] ?? '');
  }

  void _guardarReceta() {
    final nuevaReceta = {
      'titulo': tituloController.text,
      'tipo': tipoController.text,
      'ingredientes': ingredientesController.text,
      'instrucciones': instruccionesController.text,
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')) 
              ],
            ),
            SizedBox(height: 16),
            Text("Tipo de Comida", style: TextStyle(fontSize: 18)),
            TextField(
              controller: tipoController,
              decoration: InputDecoration(hintText: "Ejemplo: Postre"),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')) 
              ],
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