import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class RestaurantesScreen extends StatefulWidget {
  const RestaurantesScreen({super.key});

  @override
  _RestaurantesScreenState createState() => _RestaurantesScreenState();
}

class _RestaurantesScreenState extends State<RestaurantesScreen> {
  List<Map<String, String>> restaurantes = [];

  @override
  void initState() {
    super.initState();
    obtenerRestaurantes();
  }

  // Obtener los restaurantes de la API y procesarlos
  Future<void> obtenerRestaurantes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://www.esmadrid.com/opendata/restaurantes_v1_es.xml'));

      if (response.statusCode == 200) {
        // Parsear el XML
        final document = XmlDocument.parse(response.body);
        final restaurantesList = document.findAllElements('service').toList();

        // Recoger la información de cada restaurante
        List<Map<String, String>> nuevosRestaurantes = [];
        for (var restaurante in restaurantesList) {
          final nombre = restaurante
              .findElements('basicData')
              .first
              .findElements('name')
              .first
              .text;
          final direccion = restaurante
              .findElements('geoData')
              .first
              .findElements('address')
              .first
              .text;
          final categoria = restaurante
              .findElements('extradata')
              .first
              .findElements('categorias')
              .first
              .findElements('categoria')
              .first
              .text;

          nuevosRestaurantes.add({
            'nombre': nombre,
            'direccion': direccion,
            'categoria': categoria,
          });
        }

        setState(() {
          restaurantes = nuevosRestaurantes;
        });
      } else {
        print('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Función para mostrar los detalles de un restaurante
  void verDetalles(String nombre, String categoria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalleRestauranteScreen(nombre: nombre, categoria: categoria),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurantes'),
        centerTitle: true,
      ),
      body: restaurantes.isEmpty
          ? Center(child: CircularProgressIndicator()) // Cargando datos
          : ListView.builder(
              itemCount: restaurantes.length,
              itemBuilder: (context, index) {
                final restaurante = restaurantes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    child: ListTile(
                      title: Text(restaurante['nombre']!),
                      subtitle: Text('Categoría: ${restaurante['categoria']}'),
                      onTap: () {
                        // Al hacer clic en un restaurante, ver detalles
                        verDetalles(
                            restaurante['nombre']!, restaurante['categoria']!);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class DetalleRestauranteScreen extends StatelessWidget {
  final String nombre;
  final String categoria;

  const DetalleRestauranteScreen(
      {super.key, required this.nombre, required this.categoria});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Restaurante'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurante: $nombre',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Categoría: $categoria',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 32),
            Text(
              'Reseñas de Usuarios:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Aquí podrías agregar una lista de reseñas (puedes obtenerlas de la base de datos si las tienes)
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Usuario 1'),
                    subtitle: Text('Excelente servicio, comida deliciosa.'),
                  ),
                  ListTile(
                    title: Text('Usuario 2'),
                    subtitle:
                        Text('Buen ambiente, pero la comida podría mejorar.'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Sección de contacto
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONTACTO:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(width: 5),
                        Text("96 123 45 67"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(width: 5),
                        Text("mandangon@gmail.com"),
                      ],
                    ),
                  ],
                ),
                Icon(Icons.message, color: Colors.green, size: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
