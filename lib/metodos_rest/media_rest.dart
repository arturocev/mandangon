import 'dart:convert';
import 'package:http/http.dart' as http;

class MediaRestaurante {
  static Future<double> calcularPuntuacionMedia(int restId) async {
    final response = await http.get(Uri.parse(
        'http://localhost/mandangon/obtener_resenias.php?rest_id=$restId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['resenias'] != null) {
        return data['media']?.toDouble() ?? 0.0;
      }
    }
    return 0.0;
  }
}
