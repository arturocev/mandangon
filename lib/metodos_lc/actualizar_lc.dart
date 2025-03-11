import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

Future<void> actualizarListaCompra(int id, String nuevoNombre,
    List<Map<String, dynamic>> listasCompra, StateSetter setState) async {
  
  // Verificar si estamos en modo de depuración (debug) y mostrar un mensaje con los datos.
  if (kDebugMode) {
    print(
        "1. Intentando actualizar la lista con ID: $id y nuevo nombre: $nuevoNombre");
  }

  try {
    // Enviar la solicitud POST para actualizar la lista de compras al servidor.
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'), // URL del servidor.
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded', // Tipo de contenido.
      },
      body: {
        'id': id.toString(), // ID de la lista que queremos actualizar.
        'nombre': nuevoNombre, // Nuevo nombre para la lista.
      },
    );

    // Verificar si estamos en modo de depuración y mostrar el código de estado de la respuesta.
    if (kDebugMode) {
      print("2. Respuesta recibida de actualización: ${response.statusCode}");
    }

    // Si la respuesta tiene un código de estado 200, la actualización fue exitosa.
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("3. Lista actualizada con éxito.");
      }

      // Si la actualización fue exitosa, actualizar la lista local en la UI.
      setState(() {
        listasCompra = listasCompra.map((lista) {
          if (lista['id_list'] == id) {
            lista['nombre'] = nuevoNombre; // Actualizar el nombre de la lista.
          }
          return lista;
        }).toList();
      });
    } else {
      // Si la respuesta tiene un código diferente a 200, mostrar un error.
      if (kDebugMode) {
        print("4. Error: Respuesta inesperada al actualizar.");
      }

      // Mostrar un mensaje de error en la pantalla.
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text("Error al actualizar la lista")),
      );
    }
  } catch (e) {
    // Si ocurre un error al conectar con el servidor, mostrar un mensaje de error.
    if (kDebugMode) {
      print("5. Error al conectar con el servidor: $e");
    }

    // Mostrar un mensaje de error en la pantalla si la conexión falla.
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),
    );
  }
}
