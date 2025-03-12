import 'dart:convert';  // Para trabajar con JSON.
import 'package:flutter/foundation.dart';  // Para habilitar el modo de depuración.
import 'package:flutter/material.dart';  // Para trabajar con la interfaz de usuario.
import 'package:http/http.dart' as http;  // Para realizar solicitudes HTTP.

/// Función para confirmar el guardado de una lista en el servidor.
/// Se agregó el parámetro [usuarioId] para enviar el ID del usuario.
Future<void> confirmarLista(
    BuildContext context,
    Map<String, dynamic> lista,
    List<String> productos,
    Function onConfirm,
    int usuarioId  // Nuevo parámetro para el ID del usuario
) async {
  // Extraemos el nombre de la lista, eliminando espacios en blanco.
  String nombre = lista["nombre"].trim();

  // Imprime información relevante para depuración.
  if (kDebugMode) {
    print("ID de la lista antes de enviar: ${lista["id_list"]}");
    print("Nombre de la lista: $nombre");
    print("Productos: $productos");
    print("Usuario ID: $usuarioId");
  }

  try {
    // Realizamos una solicitud HTTP POST al servidor para guardar la lista.
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {
        'Content-Type': 'application/json',  // Indicamos que el cuerpo está en formato JSON.
      },
      body: jsonEncode({
        'id_list': lista["id_list"] ?? 0,  // Enviamos el ID de la lista o 0 si no existe.
        'nombre': nombre,                // Enviamos el nombre de la lista.
        'productos': jsonEncode(productos), // Enviamos la lista de productos como JSON.
        'usuario_id': usuarioId.toString(), // Enviamos el ID del usuario.
      }),
    );

    // Imprime la respuesta del servidor para depuración.
    if (kDebugMode) {
      print("Respuesta del servidor: ${response.body}");
      print("Código de estado: ${response.statusCode}");
    }

    // Procesamos la respuesta si el servidor responde con código 200.
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        // Llamamos a la función onConfirm con el nombre y productos actualizados.
        onConfirm(nombre, productos);

        // Cerramos la pantalla actual si es posible.
        // ignore: use_build_context_synchronously
        if (Navigator.canPop(context)) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } else {
        // En caso de error, mostramos un mensaje.
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
        );
      }
    } else {
      // Si el código de estado no es 200, mostramos un error.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al guardar la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // En caso de error en la solicitud HTTP, lo registramos y notificamos al usuario.
    if (kDebugMode) {
      print("Error en la solicitud HTTP: $e");
    }
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
