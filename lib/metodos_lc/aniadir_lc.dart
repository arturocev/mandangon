import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Función que se ejecuta al crear una nueva lista de compras
void nuevaLC(BuildContext context,
    List<Map<String, dynamic>> listasCompra, StateSetter setState) async {
  // Crear una nueva lista con un ID único generado con el tiempo actual
  final nuevaLista = {
    "id_list": DateTime.now()
        .millisecondsSinceEpoch, // Usamos el tiempo actual como ID único
    "nombre": "Nueva Lista", // Nombre predeterminado para la nueva lista
    "productos": [], // Lista vacía de productos al principio
    "color": "#FFCCCB", // Cambiar el color predeterminado a #FFCCCB
  };

  // Agregar la nueva lista a la lista de compras
  setState(() {
    listasCompra.add(nuevaLista);
  });

  // Intentar enviar la nueva lista de compras al servidor
  try {
    final response = await http.post(
      Uri.parse(
          'http://localhost/mandangon/guardar_lista.php'), // URL donde se enviará la solicitud
      headers: {
        'Content-Type': 'application/json'
      }, // Especificar que estamos enviando datos en formato JSON
      body: jsonEncode({
        'id_list':
            0, // Enviar el ID como 0, ya que el servidor asignará uno nuevo
        'nombre': nuevaLista["nombre"], // Enviar el nombre de la lista
        'productos':
            nuevaLista["productos"], // Enviar los productos de la lista
        'color': nuevaLista["color"], // Enviar el color de la lista
      }),
    );

    // Verificar si la respuesta del servidor fue exitosa
    if (response.statusCode == 200) {
      final responseData = json
          .decode(response.body); // Decodificar la respuesta en formato JSON

      if (responseData["status"] == "success") {
        // Si el servidor respondió con éxito
        // Actualizar el ID de la lista con el que asignó el servidor
        setState(() {
          nuevaLista["id_list"] = responseData["id_list"];
        });

        // Mostrar un mensaje de éxito en la interfaz
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista creada correctamente")),
        );
      } else {
        // Si el servidor no respondió con éxito, mostrar un mensaje de error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Error al crear la lista. Intente de nuevo.")),
        );
      }
    } else {
      // Si la respuesta del servidor no es 200, mostrar un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error al crear la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // Si ocurre un error de conexión, mostrar un mensaje de error
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
