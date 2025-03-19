// lib/restaurantes/restaurantes.dart
import 'package:flutter/material.dart';
import 'package:mandangon/metodos_rest/buscar_rest.dart'; // Importa el archivo de compartir_rest.dart
import 'package:mandangon/metodos_rest/obtener_rest.dart'; // Importa el archivo de compartir_rest.dart
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
    obtenerRestaurantes(setState, todosRestaurantes, listaVisible);  // Llamamos a la función para obtener los restaurantes
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
            image: AssetImage('assets/fondo1.png'), // Fondo bonito
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
                  onChanged: (query) {
                    buscarRestaurantes(query, todosRestaurantes, setState, listaVisible);
                  },
                ),
              ),
              Expanded(
                child: listaVisible.isEmpty
                    ? const Center(child: Text("No se encontraron restaurantes"))
                    : ListView.builder(
                        itemCount: listaVisible.length,
                        itemBuilder: (context, index) {
                          final restaurante = listaVisible[index];
                          String tipoComida = restaurante['rest_tipo_com'] ?? '';
                          tipoComida = tipoComida.split(',').join(', ');  // Añadir espacio después de cada coma
                          
                          return Card(
                            color: Colors.white.withOpacity(0.85),
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.restaurant, color: Colors.deepOrange),
                              title: Text(
                                restaurante['rest_nom'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('$tipoComida - ${restaurante['rest_ubi']}'),
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