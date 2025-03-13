import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> obtenerListasCompra(BuildContext context, List<Map<String, dynamic>> listasCompra, Function(Function()) setState, int usuarioId) async {
  String url = "http://localhost/mandangon/obtener_listas.php?usuario_id=$usuarioId";

  try {
    // Realizar la solicitud HTTP GET al servidor
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Decodificar la respuesta JSON
      var responseData = jsonDecode(response.body); // Suponiendo que la respuesta es un JSON

      if (responseData is List) {
        // Si la respuesta es una lista, procesamos cada elemento
        List<Map<String, dynamic>> listas = List<Map<String, dynamic>>.from(responseData);

        // Aquí puedes manejar la lista de listas de compra
        for (var lista in listas) {
          if (kDebugMode) {
            if (kDebugMode) {
              print(lista['id_list']);
            }
          }
          if (kDebugMode) {
            print(lista['nombre']);
          }
          if (kDebugMode) {
            if (kDebugMode) {
              print(lista['productos']);
            }
          }
          if (kDebugMode) {
            print(lista['list_color']);
          }
        }

        // Usar setState para actualizar el estado si es necesario
        setState(() {
          listasCompra.clear();
          listasCompra.addAll(listas);
        });
      } else if (responseData is Map && responseData['error'] == true) {
        // Si la respuesta es un objeto con un error
        if (kDebugMode) {
          if (kDebugMode) {
            print('Error: ${responseData['mensaje']}');
          }
        }
      } else {
        if (kDebugMode) {
          print('Respuesta desconocida: $responseData');
        }
      }
    } else {
      // Si la respuesta del servidor no es exitosa
      if (kDebugMode) {
        print('Error: No se pudo obtener la respuesta del servidor');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error al realizar la solicitud: $e');
    }
  }
}

// Función para mostrar las tarjetas de la lista de compras.
Widget tarjetaListaCompra(Map<String, dynamic> lista) {
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