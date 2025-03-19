import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'restaurante_card.dart';

class Restaurantes extends StatefulWidget {
  final int usuarioId;

  const Restaurantes({super.key, required this.usuarioId});

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Restaurantes", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.map, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo1.png'), // Mismo fondo bonito
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, tipo o ubicación',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.orange[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                          // Separar tipos de comida con espacio después de la coma
                          String tipoComida = restaurante['rest_tipo_com'] ?? '';
                          tipoComida = tipoComida.split(',').join(', ');  // Añadir espacio después de cada coma
                          
                          return Card(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.85),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
                              title: Text(
                                restaurante['rest_nom'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  '$tipoComida - ${restaurante['rest_ubi']}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        ),
      ),
    );
  }
}
