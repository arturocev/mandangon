import 'package:flutter/material.dart';
import 'crear_receta_screen.dart';

class RecetasScreen extends StatefulWidget {
  @override
  _RecetasScreenState createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  List<Map<String, String>> recetas = [];

  void _agregarReceta() async {
    final nuevaReceta = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CrearRecetaScreen()),
    );

    if (nuevaReceta != null) {
      setState(() {
        recetas.add(nuevaReceta);
      });
    }
  }

  void _mostrarOpciones(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Opciones'),
        content: Text('¿Qué deseas hacer con esta receta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editarReceta(index);
            },
            child: Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _verDescripcion(index);
            },
            child: Text('Ver descripción'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmarEliminar(index);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar esta receta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                recetas.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editarReceta(int index) {
    // Aquí iría la navegación a la pantalla de edición
  }

  void _verDescripcion(int index) {
    // Aquí iría la navegación a la pantalla de detalles
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset(
              'assets/image/logo.png', 
              height: 100, 
            ),
          ),
          recetas.isEmpty
              ? Center(child: Text('No hay recetas, agrega una'))
              : ListView.builder(
                  itemCount: recetas.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(recetas[index]['titulo']!),
                        subtitle: Text('${recetas[index]['tipo']} - ${recetas[index]['descripcion']}'),
                        onTap: () => _mostrarOpciones(index),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarReceta,
        child: Icon(Icons.add),
      ),
    );
  }
}