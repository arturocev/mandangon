import 'dart:convert';
import 'package:http/http.dart' as http;
import 'aleatorio_rest.dart';

Future<void> obtenerRestaurantes(Function setState, List<dynamic> todosRestaurantes, List<dynamic> listaVisible) async {
  final response = await http.get(Uri.parse('http://localhost/mandangon/obtener_restaurantes.php'));
  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);
      print('Data recibida: $data');  // Debug: Ver lo que recibimos
      setState(() {
        todosRestaurantes.clear();
        todosRestaurantes.addAll(data);
        listaVisible.clear();
        listaVisible.addAll(obtenerAleatorios(todosRestaurantes, 10));
      });
    } catch (e) {
      print('Error al parsear JSON: $e');
    }
  } else {
    print('Error en la respuesta: ${response.statusCode}');
    throw Exception('Fallo al cargar restaurantes');
  }
}
