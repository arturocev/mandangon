import 'package:flutter/material.dart';
import 'resenias.dart';


class RestauranteCard extends StatelessWidget {
  final Map<String, dynamic> restaurante;
  final int usuarioId; 

  const RestauranteCard({
    super.key,
    required this.restaurante,
    required this.usuarioId, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurante['rest_nom'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant),
                const SizedBox(width: 8),
                Text(restaurante['rest_tipo_com'],
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Ubicación: ${restaurante['rest_ubi']}'),
            const SizedBox(height: 12),
            Text('Teléfono: ${restaurante['rest_tel']}'),
            const SizedBox(height: 12),
            Text('Descripción:\n${restaurante['rest_desc']}'),
            const SizedBox(height: 12),
            // Mostrar la puntuación media en lugar de rest_cali
            Text('Puntuación media: ${restaurante['puntuacion_media']} ⭐️'),
            const SizedBox(height: 12),
            ElevatedButton(
  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Resenias(
        restId: int.parse(restaurante['id_rest'].toString()), 
        usuarioId: usuarioId,
      ),
    ),
  );
},

  child: const Text("Ver/Añadir Reseñas"),
),

          ],
        ),
      ),
    );
  }
}
