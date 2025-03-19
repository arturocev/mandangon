import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> obtenerResenias(int restId) async {
  final response = await http.get(Uri.parse(
      'http://localhost/mandangon/obtener_resenias.php?rest_id=$restId'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'resenias': data['resenias'] ?? [],
      'media': data['media']?.toDouble() ?? 0.0,
    };
  } else {
    throw Exception('Error al obtener reseñas');
  }
}
