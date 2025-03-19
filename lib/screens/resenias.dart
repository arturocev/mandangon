import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:mandangon/metodos_rsn/obtener_rsn.dart';  // Importa la función obtenerResenias
import 'package:mandangon/metodos_rsn/enviar_rsn.dart';  // Importa la función enviarResenia
import 'package:mandangon/metodos_rsn/fecha_rsn.dart';   // Importa la función formatearFecha

class Resenias extends StatefulWidget {
  final int restId;
  final int usuarioId;

  const Resenias({super.key, required this.restId, required this.usuarioId});

  @override
  ReseniasEstado createState() => ReseniasEstado();
}

class ReseniasEstado extends State<Resenias> {
  List<dynamic> resenias = [];
  double puntuacionMedia = 0.0;
  TextEditingController comentarioController = TextEditingController();
  int puntuacion = 3;

  @override
  void initState() {
    super.initState();
    obtenerReseniasData();
  }

  Future<void> obtenerReseniasData() async {
    try {
      final data = await obtenerResenias(widget.restId);
      setState(() {
        resenias = data['resenias'];
        puntuacionMedia = data['media'];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener reseñas: $e');
      }
    }
  }

  Future<void> enviarReseniaData() async {
    try {
      await enviarResenia(widget.usuarioId, widget.restId, comentarioController.text, puntuacion);
      await obtenerReseniasData();
      comentarioController.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error al añadir la reseña: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/fondo1.png'), 
            fit: BoxFit.cover,
          ),
          color: Colors.white.withOpacity(0.9),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Puntuación media destacada
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Puntuación Media',
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$puntuacionMedia ⭐️',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Lista de reseñas
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: resenias.isEmpty
                        ? const Center(child: Text("No hay reseñas aún"))
                        : ListView.separated(
                            itemCount: resenias.length,
                            separatorBuilder: (context, index) => Divider(
                              color: const Color.fromARGB(255, 103, 169, 255),
                              thickness: 1,
                            ),
                            itemBuilder: (context, index) {
                              final res = resenias[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                tileColor: Colors.orange[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                title: Text(
                                  res['usu_nombre'],
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(res['res_desc']),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber[700], size: 18),
                                        const SizedBox(width: 4),
                                        Text('${res['res_cali']}'),
                                        const Spacer(),
                                        Text(
                                          formatearFecha(res['res_fecha']),
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Campo para agregar reseña
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: comentarioController,
                        decoration: InputDecoration(
                          labelText: "Escribe tu reseña",
                          filled: true,
                          fillColor: Colors.orange[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Puntuación: "),
                          DropdownButton<int>(
                            value: puntuacion,
                            items: [1, 2, 3, 4, 5]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.toString()),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => puntuacion = val!),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: enviarReseniaData,
                            icon: const Icon(Icons.send, color: Colors.black),
                            label: const Text("Enviar", style: TextStyle(color: Colors.black)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 80, 255, 220),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
