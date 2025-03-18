import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Resenias extends StatefulWidget {
  final int restId;
  final int usuarioId; 

  const Resenias({super.key, required this.restId, required this.usuarioId});
  @override
  ReseniasEstado createState() => ReseniasEstado();
}

class ReseniasEstado extends State<Resenias> {
  List<dynamic> resenias = [];
  TextEditingController comentarioController = TextEditingController();
  int puntuacion = 3;

  @override
  void initState() {
    super.initState();
    obtenerResenias();
  }

  Future<void> obtenerResenias() async {
    final response = await http.get(Uri.parse(
        'http://localhost/mandangon/obtener_resenias.php?rest_id=${widget.restId}'));
    if (response.statusCode == 200) {
      setState(() {
        resenias = json.decode(response.body);
      });
    }
  }


Future<void> enviarResenia() async {
  final response = await http.post(
    Uri.parse('http://localhost/mandangon/insertar_resenias.php'),
    body: {
      'usuarioId': widget.usuarioId.toString(), 
      'restauranteId': widget.restId.toString(),
      'descripcion': comentarioController.text,
      'calificacion': puntuacion.toString(),
    },
  );

  if (response.statusCode == 200) {
    print('Reseña añadida correctamente');
    obtenerResenias(); // recargar para que aparezca
    comentarioController.clear();
  } else {
    print('Error al añadir la reseña');
  }
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reseñas")),
      body: Column(
        children: [
          Expanded(
            child: resenias.isEmpty
                ? const Center(child: Text("No hay reseñas aún"))
                : ListView.builder(
                    itemCount: resenias.length,
                    itemBuilder: (context, index) {
                      final res = resenias[index];
                      return ListTile(
                        title: Text(res['res_desc']),
                        subtitle: Text('Puntuación: ${res['res_cali']} ⭐️'),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: comentarioController,
                  decoration:
                      const InputDecoration(labelText: "Escribe tu reseña"),
                ),
                Row(
                  children: [
                    const Text("Puntuación: "),
                    DropdownButton<int>(
                      value: puntuacion,
                      items: [1, 2, 3, 4, 5]
                          .map((e) => DropdownMenuItem(
                              child: Text(e.toString()), value: e))
                          .toList(),
                      onChanged: (val) => setState(() => puntuacion = val!),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: enviarResenia,
                      child: const Text("Enviar"),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
