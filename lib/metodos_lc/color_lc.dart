import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Paquete para hacer solicitudes HTTP
import 'dart:convert';  // Paquete para convertir datos a formato JSON

// Función para convertir un color hexadecimal a un color de Flutter
Color convertirColor(String colorHex) {
  return Color(int.parse(colorHex.replaceAll("#", "0xFF")));
}
// Función que actualiza el color de una lista de compras en el servidor
Future<void> actualizarColorLista(BuildContext context, int idLista, String nuevoColor) async {
  try {
    // Hacemos una solicitud POST al servidor para actualizar el color de la lista
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/actualizar_color_lista.php'), // Endpoint para actualizar el color
      headers: {
        'Content-Type': 'application/json',  // Especificamos que estamos enviando datos en formato JSON
      },
      body: jsonEncode({
        'id_list': idLista,  // El ID de la lista que se va a actualizar
        'list_color': nuevoColor,  // El nuevo color que se desea asignar
      }),
    );

    // Verificamos si la respuesta del servidor es exitosa (código 200)
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);  // Decodificamos la respuesta del servidor

      // Si el servidor responde con éxito
      if (responseData["status"] == "success") {
        // Mostramos un mensaje de éxito al usuario
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Color actualizado correctamente")),  // Mensaje de éxito
        );
      } else {
        // Si el servidor responde con un error, mostramos un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al actualizar el color")),  // Mensaje de error
        );
      }
    } else {
      // Si la respuesta del servidor no es 200, mostramos un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al conectar con el servidor")),  // Mensaje de error de conexión
      );
    }
  } catch (e) {
    // Si ocurre una excepción durante la solicitud (por ejemplo, problemas de red)
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),  // Mensaje de error de conexión
    );
  }
}
