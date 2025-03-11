import 'package:flutter/foundation.dart';  // Para habilitar el modo de depuración.
import 'package:flutter/material.dart';  // Para usar los widgets de la interfaz de usuario.
import 'package:http/http.dart' as http;  // Para realizar solicitudes HTTP.

/// Función para eliminar una lista de compras en el servidor
Future<void> eliminarListaCompra(int idList, BuildContext context) async {
  // Si estamos en modo de depuración, imprimimos el ID de la lista que vamos a eliminar
  if (kDebugMode) {
    print("1. Intentando eliminar la lista con ID: $idList");
  }

  try {
    // Realizamos una solicitud HTTP POST para eliminar la lista
    final response = await http.post(
      Uri.parse('http://localhost/mandangon/eliminar_lista.php'),  // Endpoint para eliminar la lista
      body: {
        'id_list': idList.toString(),  // Enviamos el ID de la lista a eliminar
      },
    );

    // Si estamos en modo de depuración, imprimimos el código de estado de la respuesta
    if (kDebugMode) {
      print("2. Respuesta recibida de eliminación: ${response.statusCode}");
    }

    // Si la respuesta del servidor es exitosa (código 200), mostramos un mensaje de éxito
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("3. Lista eliminada con éxito.");
      }

      // Mostramos un SnackBar con un mensaje de éxito
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lista eliminada exitosamente")),
      );
    } else {
      // Si la respuesta del servidor no es la esperada, mostramos un mensaje de error
      if (kDebugMode) {
        print("4. Error: Respuesta inesperada al eliminar.");
      }

      // Mostramos un SnackBar con un mensaje de error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al eliminar la lista")),
      );
    }
  } catch (e) {
    // Si ocurre un error durante la solicitud HTTP (como problemas de conexión), lo capturamos
    if (kDebugMode) {
      print("5. Error al conectar con el servidor: $e");
    }

    // Mostramos un SnackBar con un mensaje de error de conexión
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error al conectar con el servidor")),
    );
  }
}
