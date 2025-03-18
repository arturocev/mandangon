import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'restaurante_card.dart';
//import 'mapa_restaurantes.dart'; // Pantalla futura para el mapa

class Restaurantes extends StatefulWidget {
  final int usuarioId;

  const Restaurantes(
      {super.key,
      required this.usuarioId}); // Asegurarte de que este parámetro sea requerido

  @override
  RestEstado createState() => RestEstado();
}

class RestEstado extends State<Restaurantes> {
  List<dynamic> todosRestaurantes = [];
  List<dynamic> listaVisible = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    obtenerRestaurantes();
  }

  Future<void> obtenerRestaurantes() async {
    final response = await http
        .get(Uri.parse('http://localhost/mandangon/obtener_restaurantes.php'));
    if (response.statusCode == 200) {
      setState(() {
        todosRestaurantes = json.decode(response.body);
        listaVisible = obtenerAleatorios(todosRestaurantes, 10);
      });
    } else {
      throw Exception('Fallo al cargar restaurantes');
    }
  }

  List<dynamic> obtenerAleatorios(List<dynamic> lista, int cantidad) {
    lista.shuffle(Random());
    return lista.take(cantidad).toList();
  }

  void buscarRestaurantes(String query) {
    final resultados = todosRestaurantes.where((rest) {
      final nombre = rest['rest_nom'].toString().toLowerCase();
      final tipo = rest['rest_tipo_com'].toString().toLowerCase();
      final ubicacion = rest['rest_ubi'].toString().toLowerCase();
      final q = query.toLowerCase();
      return nombre.contains(q) || tipo.contains(q) || ubicacion.contains(q);
    }).toList();

    setState(() {
      listaVisible =
          query.isEmpty ? obtenerAleatorios(todosRestaurantes, 10) : resultados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurantes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              //Navigator.push(
              //context,
              //MaterialPageRoute(builder: (context) => const MapaRestaurantes()),
              //);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, tipo o ubicación',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: buscarRestaurantes,
            ),
          ),
          Expanded(
            child: listaVisible.isEmpty
                ? const Center(child: Text("No se encontraron restaurantes"))
                : ListView.builder(
                    itemCount: listaVisible.length,
                    itemBuilder: (context, index) {
                      final restaurante = listaVisible[index];
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: Icon(Icons
                              .restaurant), // Puedes cambiar a un icono dinámico
                          title: Text(restaurante['rest_nom']),
                          subtitle: Text(
                              '${restaurante['rest_tipo_com']} - ${restaurante['rest_ubi']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RestauranteCard(
                                  restaurante: restaurante,
                                  usuarioId: widget.usuarioId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
