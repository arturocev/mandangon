import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Función para obtener las listas de compra desde el servidor y actualizarlas en la UI.
Future<void> obtenerListasCompra(BuildContext context, List<Map<String, dynamic>> listasCompra, Function(Function()) setState) async {
  if (kDebugMode) {
    print("1. Intentando obtener listas de compra...");
  }

  try {
    // Realizamos una solicitud GET al servidor para obtener las listas de compra.
    final response = await http.get(Uri.parse('http://localhost/mandangon/obtener_listas.php'));

    if (kDebugMode) {
      print("2. Respuesta recibida: ${response.statusCode}");
    }

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("3. Respuesta del servidor: ${response.body}");
      }
      // Decodificamos la respuesta del servidor (en formato JSON) a una lista de listas de compra.
      List<dynamic> listas = json.decode(response.body);

      // Actualizamos el estado de la UI con las listas de compra obtenidas.
      setState(() {
        listasCompra.clear(); // Limpiar la lista actual de listas de compra
        // Agregamos las nuevas listas obtenidas.
        listasCompra.addAll(listas.map((lista) {
          return {
            'id_list': int.tryParse(lista['id_list'].toString()) ?? 0, // Convertir id_list a int
            'nombre': lista['nombre'], // Asignar el nombre de la lista
            'productos': List<String>.from(lista['productos']), // Convertir productos a una lista de strings
            'list_color': lista['color'] ?? "#FFFFFF", // Asignar el color de la lista (por defecto blanco)
          };
        }).toList());
      });

      if (kDebugMode) {
        print("4. Listas de compra cargadas con éxito.");
      }
    } else {
      if (kDebugMode) {
        print("5. Error: Respuesta inesperada del servidor.");
      }
      
      // Si ocurre un error al obtener las listas, mostramos un mensaje de error.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al cargar las listas. Intente de nuevo.")),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("6. Error al conectar con el servidor: $e");
    }

    // Si ocurre un error al conectar con el servidor, mostramos un mensaje de error.
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor.")),
    );
  }
}

// Función para mostrar las tarjetas de la lista de compras.
Widget listaCompraCard(Map<String, dynamic> lista) {
  // Convertir el color hexadecimal de la lista en un objeto Color de Flutter
  Color colorCard = Color(int.parse("0xFF${lista['color'].substring(1)}")); // Convertir el color hexadecimal a Color

  // Crear y retornar la tarjeta de la lista de compra con el color y los datos de la lista
  return Card(
    color: colorCard, // Cambiar el color de la tarjeta según el color de la lista
    child: ListTile(
      title: Text(lista['nombre']), // Mostrar el nombre de la lista de compra
      subtitle: Text(lista['productos'].join(", ")), // Mostrar los productos de la lista (unidos por coma)
    ),
  );
}