import 'package:flutter/material.dart';
import 'crear_receta_screen.dart';

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  _RecetasScreenState createState() => _RecetasScreenState();
}

class _RecetasScreenState extends State<RecetasScreen> {
  List<Map<String, String>> recetas = [];

  @override
  void initState() {
    super.initState();
  }

  

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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Opciones"),
          content: Text("¿Qué quieres hacer con esta receta?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _editarReceta(index);
              },
              child: Text("Editar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _verDescripcion(index);
              },
              child: Text("Ver Descripción"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _eliminarReceta(index);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  void _editarReceta(int index) async {
    final recetaEditada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearRecetaScreen(receta: recetas[index]),
      ),
    );

    if (recetaEditada != null) {
      setState(() {
        recetas[index] = recetaEditada;
      });
    }
  }

  void _verDescripcion(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(recetas[index]['titulo']!),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tipo: ${recetas[index]['tipo']}"),
              SizedBox(height: 10),
              Text("Ingredientes: ${recetas[index]['ingredientes']}"),
              SizedBox(height: 10),
              Text("Instrucciones: ${recetas[index]['instrucciones']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

  void _eliminarReceta(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar eliminación"),
          content: Text("¿Estás seguro de que deseas eliminar esta receta?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  recetas.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 100), 
          Expanded(
            child: ListView.builder(
              itemCount: recetas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(recetas[index]['titulo']!),
                    subtitle: Text(recetas[index]['tipo']!),
                    onTap: () => _mostrarOpciones(index),
                  ),
                );
              },
            ),
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