import 'package:http/http.dart' as http;

Future<void> enviarResenia(int usuarioId, int restId, String comentario, int puntuacion) async {
  final response = await http.post(
    Uri.parse('http://localhost/mandangon/insertar_resenias.php'),
    body: {
      'usuarioId': usuarioId.toString(),
      'restauranteId': restId.toString(),
      'descripcion': comentario,
      'calificacion': puntuacion.toString(),
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Error al añadir la reseña');
  }
}
