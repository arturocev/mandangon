import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Función que se ejecuta al crear una nueva lista de compras.
void nuevaLC(BuildContext context, List<Map<String, dynamic>> listasCompra, StateSetter setState, int usuarioId) async {
  // Crear una nueva lista con un ID temporal basado en el tiempo actual.
  final nuevaLista = {
    "id_list": DateTime.now().millisecondsSinceEpoch, // ID temporal
    "nombre": "Nueva Lista",
    "productos": [],
    "color": "#FFCCCB",
  };

  // Agregar la nueva lista temporalmente a la lista de compras en la UI.
  setState(() {
    listasCompra.add(nuevaLista);
  });

  // Imprimir valores de depuración.
  if (kDebugMode) {
    print("DEBUG: Nueva lista creada en UI: $nuevaLista");
    print("DEBUG: usuarioId enviado: $usuarioId");
  }

  // Intentar enviar la nueva lista al servidor.
  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id_list': 0, // 0 indica que es una nueva lista.
        'nombre': nuevaLista["nombre"],
        'productos': nuevaLista["productos"],
        'color': nuevaLista["color"],
        'usuario_id': usuarioId, // Pasar el ID del usuario correcto.
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData["status"] == "success") {
        // Actualizar el ID de la lista con el asignado por el servidor.
        setState(() {
          nuevaLista["id_list"] = responseData["id_list"];
        });

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lista creada correctamente")),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al crear la lista. Intente de nuevo.")),
      );
    }
  } catch (e) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo conectar con el servidor.")),
    );
  }
}
