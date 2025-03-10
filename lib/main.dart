import 'package:flutter/foundation.dart';
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

void masListaCompra() async {
  // Crear una nueva lista en el estado local
  final nuevaLista = {
    "id_list": DateTime.now().millisecondsSinceEpoch, // Generar un ID único
    "nombre": "Nueva Lista",
    "productos": [],
  };

  setState(() {
    listasCompra.add(nuevaLista);
  });

  // Enviar la nueva lista al servidor para guardarla en la base de datos
  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_list': 0, // ID 0 indica que es una nueva lista
        'nombre': nuevaLista["nombre"],
        'productos': nuevaLista["productos"],
      }),
    );

    if (response.statusCode == 200) {
      // Parsear la respuesta JSON
      final responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        // Actualizar el id_list de la lista con el ID generado por el servidor
        setState(() {
          nuevaLista["id_list"] = responseData["id_list"]; // Asignar el ID generado por el servidor
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista creada correctamente")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
  void mostrarOpcionesLista(BuildContext context, int index) {
    final lista = listasCompra[index];

    // Depuración: Verificar el id_list de la lista seleccionada
    print("ID de la lista seleccionada: ${lista["id_list"]}");
    print("Nombre de la lista seleccionada: ${lista["nombre"]}");
    print("Productos de la lista seleccionada: ${lista["productos"]}");

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
                        lista: {
                          "id_list": lista["id_list"], // Pasar el id_list correctamente
                          "nombre": lista["nombre"],
                          "productos": lista["productos"],
                        },
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
                        lista: {
                          "id_list": lista["id_list"], // Pasar el id_list correctamente
                          "nombre": lista["nombre"],
                          "productos": lista["productos"],
                        },
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
  final lista = listasCompra[index];

  // Convertir el id_list a int
  final idList = int.tryParse(lista["id_list"].toString()) ?? 0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("¿Eliminar lista?"),
        content: const Text("¿Estás seguro de que quieres eliminar esta lista?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context), // Cerrar el diálogo sin hacer nada
          ),
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () {
              // Eliminar la lista de la base de datos
              eliminarListaCompra(idList);

              // Eliminar la lista del estado local
              setState(() {
                listasCompra.removeAt(index);
              });

              // Cerrar el diálogo
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Future<void> eliminarListaCompra(int idList) async {
  if (kDebugMode) {
    print("1. Intentando eliminar la lista con ID: $idList");
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/eliminar_lista.php'),
      body: {
        'id_list': idList.toString(), // Enviar el id_list como parámetro
      },
    );

    if (kDebugMode) {
      print("2. Respuesta recibida de eliminación: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("3. Lista eliminada con éxito.");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lista eliminada exitosamente")),
      );
    } else {
      if (kDebugMode) {
        print("4. Error: Respuesta inesperada al eliminar.");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar la lista")),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("5. Error al conectar con el servidor: $e");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),
    );
  }
}
Future<void> obtenerListasCompra() async {
  if (kDebugMode) {
    print("1. Intentando obtener listas de compra...");
  }

  try {
    final response = await http.get(Uri.parse('http://localhost/mandangon/obtener_listas.php'));

    if (kDebugMode) {
      print("2. Respuesta recibida: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("3. Respuesta del servidor: ${response.body}");
      }
      List<dynamic> listas = json.decode(response.body);

      setState(() {
        listasCompra = listas.map((lista) {
          return {
            'id_list': int.tryParse(lista['id_list'].toString()) ?? 0, // Convertir a int
            'nombre': lista['nombre'],
            'productos': List<String>.from(lista['productos']),
          };
        }).toList();
      });

      if (kDebugMode) {
        print("4. Listas de compra cargadas con éxito.");
      }
    } else {
      if (kDebugMode) {
        print("5. Error: Respuesta inesperada del servidor.");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar las listas. Intente de nuevo.")),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("6. Error al conectar con el servidor: $e");
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor.")),
    );
  }
} // Función para actualizar lista de compra
  Future<void> actualizarListaCompra(int id, String nuevoNombre) async {
    if (kDebugMode) {
      print("1. Intentando actualizar la lista con ID: $id y nuevo nombre: $nuevoNombre");
    }

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

      if (kDebugMode) {
        print("2. Respuesta recibida de actualización: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("3. Lista actualizada con éxito.");
        }
        setState(() {
          listasCompra = listasCompra.map((lista) {
            if (lista['id_list'] == id) {
              lista['nombre'] = nuevoNombre; // Actualiza el nombre
            }
            return lista;
          }).toList();
        });
      } else {
        if (kDebugMode) {
          print("4. Error: Respuesta inesperada al actualizar.");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar la lista")),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("5. Error al conectar con el servidor: $e");
      }
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
                      final lista = listasCompra[index];
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
                                  lista["nombre"],
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