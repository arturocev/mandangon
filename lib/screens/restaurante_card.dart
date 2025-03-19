import 'package:flutter/material.dart';
import 'package:mandangon/metodos_rest/media_rest.dart'; // Importa el archivo de media_rest.dart
import 'package:mandangon/metodos_rest/web_rest.dart'; // Importa el archivo de web_rest.dart
import 'package:mandangon/metodos_rest/direccion_rest.dart'; // Importa el archivo de direccion_rest.dart
import 'package:mandangon/metodos_rest/compartir_rest.dart'; // Importa el archivo de compartir_rest.dart
import 'resenias.dart';

class RestauranteCard extends StatefulWidget {
  final Map<String, dynamic> restaurante;
  final int usuarioId;

  const RestauranteCard({
    super.key,
    required this.restaurante,
    required this.usuarioId,
  });

  @override
  State<RestauranteCard> createState() => _RestauranteCardState();
}

class _RestauranteCardState extends State<RestauranteCard> {
  double puntuacionMedia = 0.0;

  @override
  void initState() {
    super.initState();
    calcularPuntuacionMedia();
  }

  Future<void> calcularPuntuacionMedia() async {
    puntuacionMedia = await MediaRestaurante.calcularPuntuacionMedia(int.parse(widget.restaurante['id_rest'].toString()));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String tiposComida = widget.restaurante['rest_tipo_com'] ?? '';
    List<String> tiposLista = tiposComida.split(',');
    tiposComida = tiposLista.map((tipo) => tipo.trim()).join(', ');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Restaurante', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurante['rest_nom'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.restaurant_menu, color: Colors.deepOrange),
                          const SizedBox(width: 8),
                          Text(
                            tiposComida,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '📍 Ubicación:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () => DireccionRestaurante.abrirDireccion(widget.restaurante['rest_ubi'] ?? '', context),
                        child: Text(
                          widget.restaurante['rest_ubi'] ?? '',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 9, 77, 133),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '📞 Teléfono:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.restaurante['rest_tel']),
                      const SizedBox(height: 12),
                      Text(
                        '📝 Descripción:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.restaurante['rest_desc']?.trimLeft() ?? '',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '⭐️ Puntuación media:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$puntuacionMedia'),
                      const SizedBox(height: 12),
                      if (widget.restaurante['rest_web'] != null)
                        TextButton(
                          onPressed: () => WebRestaurante.visitarWeb(widget.restaurante['rest_web'] ?? '', context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.web, color: Color.fromARGB(255, 9, 77, 133)),
                              const SizedBox(width: 8),
                              const Text(
                                "Visitar página web",
                                style: TextStyle(color: Color.fromARGB(255, 9, 77, 133)),
                              ),
                            ],
                          ),
                        ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 80, 255, 220),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Resenias(
                                  restId: int.parse(widget.restaurante['id_rest'].toString()),
                                  usuarioId: widget.usuarioId,
                                ),
                              ),
                            );
                            calcularPuntuacionMedia();
                          },
                          child: const Text("Ver/Añadir Reseñas", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.deepOrange),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Compartir restaurante"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.message, color: Colors.green),
                                    title: const Text("Compartir por WhatsApp"),
                                    onTap: () {
                                      CompartirRestaurante.compartirRestaurante(
                                          'whatsapp',
                                          widget.restaurante['rest_web'] ?? '',
                                          widget.restaurante['rest_nom'],
                                          widget.restaurante['rest_ubi'] ?? '',
                                          context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.email, color: Colors.blue),
                                    title: const Text("Enviar por Correo"),
                                    onTap: () {
                                      CompartirRestaurante.compartirRestaurante(
                                          'email',
                                          widget.restaurante['rest_web'] ?? '',
                                          widget.restaurante['rest_nom'],
                                          widget.restaurante['rest_ubi'] ?? '',
                                          context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.copy, color: Colors.black),
                                    title: const Text("Copiar al Portapapeles"),
                                    onTap: () {
                                      CompartirRestaurante.compartirRestaurante(
                                          'copy',
                                          widget.restaurante['rest_web'] ?? '',
                                          widget.restaurante['rest_nom'],
                                          widget.restaurante['rest_ubi'] ?? '',
                                          context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
