import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 
import 'screens/lista_compra_screen.dart';

void main() {
  runApp(MandangonApp());
}

class MandangonApp extends StatelessWidget {
  const MandangonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  PPEstado createState() => PPEstado();
}

class PPEstado extends State<PantallaPrincipal> {
  List<Map<String, dynamic>> listasCompra = [];

  @override
  void initState() {
    super.initState();
    obtenerListasCompra(); // Cargar las listas desde el servidor
  }

  void masListaCompra() {
    setState(() {
      listasCompra.add({
        "id": DateTime.now().millisecondsSinceEpoch, // Generamos un ID único para las nuevas listas
        "nombre": "Nueva Lista",
        "productos": [],
      });
    });
  }

  void mostrarOpcionesLista(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Opciones de Lista"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Editar"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LCScreen(
                        editable: true,
                        lista: listasCompra[index],
                        onConfirm: (nombre, productos) {
                          setState(() {
                            listasCompra[index]["nombre"] = nombre;
                            listasCompra[index]["productos"] = productos;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Ver"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LCScreen(
                        editable: false,
                        lista: listasCompra[index],
                        onConfirm: (nombre, productos) {},
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text("Eliminar"),
                onTap: () {
                  Navigator.pop(context);
                  confirmarEliminacion(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void confirmarEliminacion(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Eliminar lista?"),
          content: const Text("¿Estás seguro de que quieres eliminar esta lista?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  listasCompra.removeAt(index);
                });
                eliminarListaCompra(listasCompra[index]["id"]);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // Función para obtener las listas de la base de datos
  Future<void> obtenerListasCompra() async {
    print("1. Intentando obtener listas de compra...");

    try {
      final response = await http.get(Uri.parse('http://localhost/mandangon/obtener_listas.php'));
    
      print("2. Respuesta recibida: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("3. Respuesta del servidor: ${response.body}");
        List<dynamic> listas = json.decode(response.body);

        setState(() {
          listasCompra = listas.map((lista) {
            return {
              'id': lista['id'],
              'nombre': lista['nombre'],
              'productos': List<String>.from(lista['productos']),
            };
          }).toList();
        });

        print("4. Listas de compra cargadas con éxito.");
      } else {
        print("5. Error: Respuesta inesperada del servidor.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al cargar las listas. Intente de nuevo.")),
        );
      }
    } catch (e) {
      print("6. Error al conectar con el servidor: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor.")),
      );
    }
  }

  // Función para eliminar lista de compra
  Future<void> eliminarListaCompra(int id) async {
    print("1. Intentando eliminar la lista con ID: $id");

    try {
      final response = await http.post(
        Uri.parse('http://localhost/mandangon/eliminar_lista.php'),
        body: {
          'id': id.toString(),
        },
      );

      print("2. Respuesta recibida de eliminación: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("3. Lista eliminada con éxito.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista eliminada exitosamente")),
        );
      } else {
        print("4. Error: Respuesta inesperada al eliminar.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al eliminar la lista")),
        );
      }
    } catch (e) {
      print("5. Error al conectar con el servidor: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  }

  // Función para actualizar lista de compra
  Future<void> actualizarListaCompra(int id, String nuevoNombre) async {
    print("1. Intentando actualizar la lista con ID: $id y nuevo nombre: $nuevoNombre");

    try {
      final response = await http.post(
        Uri.parse('http://localhost/mandangon/guardar_lista.php'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id': id.toString(),
          'nombre': nuevoNombre,
        },
      );

      print("2. Respuesta recibida de actualización: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("3. Lista actualizada con éxito.");
        setState(() {
          listasCompra = listasCompra.map((lista) {
            if (lista['id'] == id) {
              lista['nombre'] = nuevoNombre; // Actualiza el nombre
            }
            return lista;
          }).toList();
        });
      } else {
        print("4. Error: Respuesta inesperada al actualizar.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar la lista")),
        );
      }
    } catch (e) {
      print("5. Error al conectar con el servidor: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Center(child: Image.asset("assets/logo.png", height: 80)),
          const SizedBox(height: 20),
          Expanded(
            child: listasCompra.isEmpty
                ? const Center(child: Text("No hay listas de compra"))
                : ListView.builder(
                    itemCount: listasCompra.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 208, 208, 1),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: InkWell(
                              onTap: () => mostrarOpcionesLista(context, index),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  listasCompra[index]["nombre"],
                                  style: const TextStyle(
                                    fontFamily: 'DancingScript',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (listasCompra.length < 25)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: IconButton(
                icon: const Icon(Icons.add_circle, size: 50, color: Colors.brown),
                onPressed: masListaCompra,
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Recetas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Restaurantes",
          ),
        ],
        onTap: (index) {},
      ),
    );
  }
}
