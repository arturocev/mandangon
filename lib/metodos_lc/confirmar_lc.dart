import 'dart:convert';  // Para trabajar con JSON.
import 'package:flutter/foundation.dart';  // Para habilitar el modo de depuración.
import 'package:flutter/material.dart';  // Para trabajar con la interfaz de usuario.
import 'package:http/http.dart' as http;  // Para realizar solicitudes HTTP.

/// Función para confirmar el guardado de una lista en el servidor
Future<void> confirmarLista(BuildContext context, Map<String, dynamic> lista,
    List<String> productos, Function onConfirm) async {
  
  // Extraemos el nombre de la lista, eliminando espacios en blanco al inicio y al final
  String nombre = lista["nombre"].trim();

  // Si estamos en modo de depuración, imprimimos información relevante
  if (kDebugMode) {
    print("ID de la lista antes de enviar: ${lista["id_list"]}");
    print("Nombre de la lista: $nombre");
    print("Productos: $productos");
  }

  try {
    // Realizamos una solicitud HTTP POST al servidor para guardar la lista
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),  // Endpoint donde se guardará la lista
      headers: {
        'Content-Type': 'application/json',  // Indicamos que el cuerpo de la solicitud está en formato JSON
      },
      body: jsonEncode({
        'id_list': lista["id_list"] ?? 0,  // Enviamos el ID de la lista (si no tiene, lo establecemos como 0)
        'nombre': nombre,  // Enviamos el nombre de la lista
        'productos': productos,  // Enviamos la lista de productos
      }),
    );

    // Si estamos en modo de depuración, imprimimos la respuesta y el código de estado
    if (kDebugMode) {
      print("Respuesta del servidor: ${response.body}");
      print("Código de estado: ${response.statusCode}");
    }

    // Si la respuesta del servidor es exitosa (código 200), procesamos los datos
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);  // Decodificamos la respuesta en JSON

      // Si el estado de la respuesta es 'success', llamamos a la función de confirmación
      if (responseData["status"] == "success") {
        onConfirm(nombre, productos);  // Llamamos a la función onConfirm con el nombre y los productos de la lista

        // Si es posible, cerramos la pantalla actual (pop de la navegación)
        // ignore: use_build_context_synchronously
        if (Navigator.canPop(context)) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } else {
        // Si el estado es diferente a 'success', mostramos un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error al guardar la lista. Intente de nuevo.")),
        );
      }
    } else {
      // Si el código de estado no es 200, mostramos un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al guardar la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // Si ocurre un error durante la solicitud HTTP, lo capturamos y mostramos un mensaje de error
    if (kDebugMode) {
      print("Error en la solicitud HTTP: $e");
    }

    // Mostramos un mensaje de error al usuario si no se pudo conectar al servidor
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
