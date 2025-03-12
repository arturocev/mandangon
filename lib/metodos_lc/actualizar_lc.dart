import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path/path.dart';

Future<void> actualizarListaCompra(
    int idLista,
    String nuevoNombre,
    List<Map<String, dynamic>> listasCompra,
    StateSetter setState,
    int usuarioId, // Este valor debe provenir del usuario que inició sesión
    List<String> productos
) async {
  // Imprime todos los valores antes de enviarlos para asegurarnos de que están completos
  if (kDebugMode) {
    print("DEBUG: idLista: $idLista");
    print("DEBUG: nuevoNombre: $nuevoNombre");
    print("DEBUG: usuarioId: $usuarioId");
    print("DEBUG: productos (original): $productos");
  }

  // Filtrar productos vacíos (por si acaso)
  final productosLimpiados = productos.where((p) => p.trim().isNotEmpty).toList();
  if (kDebugMode) {
    print("DEBUG: productosLimpiados: $productosLimpiados");
  }

  // Construir el cuerpo de la petición
  final bodyData = {
    'id_list': idLista.toString(),
    'nombre': nuevoNombre,
    'productos': jsonEncode(productosLimpiados),
    'usuario_id': usuarioId.toString(),
  };

  if (kDebugMode) {
    print("DEBUG: Body enviado: ${jsonEncode(bodyData)}");
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/guardar_lista.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(bodyData),
    );

    if (kDebugMode) {
      print("DEBUG: Respuesta HTTP: ${response.statusCode}");
      print("DEBUG: Respuesta: ${response.body}");
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData["status"] == "success") {
        if (kDebugMode) {
          print("DEBUG: Lista actualizada con éxito.");
        }
        setState(() {
          for (var lista in listasCompra) {
            if (lista['id_list'] == idLista) {
              lista['nombre'] = nuevoNombre;
              lista['productos'] = productosLimpiados;
            }
          }
        });
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          const SnackBar(content: Text("Lista actualizada correctamente")),
        );
      } else {
        if (kDebugMode) {
          print("DEBUG: Error del servidor: ${responseData["message"]}");
        }
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text("Error: ${responseData["message"]}")),
        );
      }
    } else {
      if (kDebugMode) {
        print("DEBUG: Respuesta inesperada del servidor.");
      }
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text("Error al actualizar la lista")),
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print("DEBUG: Error al conectar con el servidor: $e");
    }
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),
    );
  }
}
