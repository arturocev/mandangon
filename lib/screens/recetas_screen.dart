import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'crear_receta_screen.dart';

class RecetasScreen extends StatefulWidget {
  const RecetasScreen({super.key});

  @override
  RecetasScreenState createState() => RecetasScreenState();
}

class RecetasScreenState extends State<RecetasScreen> {
  // Lista para almacenar las recetas
  List<Map<String, String>> recetas = [];

  @override
  void initState() {
    super.initState();
  }

  // Función para agregar una nueva receta
  void agregarReceta() async {
    // Navega a la pantalla CrearRecetaScreen y espera la receta creada
    final nuevaReceta = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CrearRecetaScreen()),
    );

    // Si la receta no es nula, la agrega a la lista de recetas
    if (nuevaReceta != null) {
      setState(() {
        recetas.add(nuevaReceta);
      });
    }
  }

  // Función para eliminar una receta
  Future<void> eliminarReceta(int index) async {
    // Confirmar eliminación
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
              onPressed: () async {
                Navigator.pop(context);
                // Llamar a la API para eliminar la receta
                await _eliminarRecetaDesdeServidor(recetas[index]['id_rec']);
                setState(() {
                  // Elimina la receta de la lista
                  recetas.removeAt(index);
                });
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  // Función que se comunica con el servidor para eliminar una receta
  Future<void> _eliminarRecetaDesdeServidor(String? idReceta) async {
    final String url = 'http://localhost/eliminar_receta.php';

    try {
      // Realiza una solicitud POST al servidor para eliminar la receta
      final response = await http.post(
        Uri.parse(url),
        body: {'rec_id': idReceta ?? ''},
      );

      final responseData = json.decode(response.body);

      if (responseData['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Receta eliminada correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la receta')),
        );
      }
    } catch (error) {
      print("Error al eliminar la receta: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión')),
      );
    }
  }

  // Función para mostrar las opciones (editar, ver descripción, eliminar) de una receta
  void mostrarOpciones(int index) {
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
                editarReceta(index);
              },
              child: Text("Editar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                verDescripcion(index);
              },
              child: Text("Ver Descripción"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                eliminarReceta(index);
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  // Función para editar una receta
  void editarReceta(int index) async {
    final recetaEditada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearRecetaScreen(receta: recetas[index]),
      ),
    );

    // Si la receta ha sido editada, se actualiza en la lista
    if (recetaEditada != null) {
      setState(() {
        recetas[index] = recetaEditada;
      });
    }
  }

  // Función para ver la descripción de una receta
  void verDescripcion(int index) {
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

  // Función para mostrar la imagen de la receta (si existe)
  Widget mostrarImagen(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        width: 50,
        height: 50,
        color: Colors.grey[300],
        child: Icon(Icons.image, color: Colors.grey[700]),
      );
    }

    if (kIsWeb) {
      return Image.network(path, width: 50, height: 50, fit: BoxFit.cover);
    } else {
      return Image.file(File(path), width: 50, height: 50, fit: BoxFit.cover);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Icono de perfil
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Aquí se debe navegar a la pantalla de perfil
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilScreen()),
              );
            },
          ),
          // Icono de configuración
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Aquí se debe navegar a la pantalla de configuración
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ConfiguracionScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.asset('assets/images/logo.png', height: 100),
          Expanded(
            child: recetas.isEmpty
                ? Center(
                    child: Text(
                      "No hay recetas disponibles",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: recetas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 102, 21, 21),
                        child: ListTile(
                          leading: mostrarImagen(recetas[index]['imagen']),
                          title: Text(
                            recetas[index]['titulo']!,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            recetas[index]['tipo']!,
                            style: TextStyle(color: Colors.white70),
                          ),
                          onTap: () => mostrarOpciones(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: agregarReceta,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Pantalla de perfil (temporal)
class PerfilScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Center(child: const Text('Pantalla de perfil')),
    );
  }
}

// Pantalla de configuración (temporal)
class ConfiguracionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Center(child: const Text('Pantalla de configuración')),
    );
  }
}
