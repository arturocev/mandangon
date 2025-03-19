import 'package:flutter/material.dart';
import 'resenias.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart'; // Para abrir enlaces
import 'package:flutter/services.dart'; // Para copiar al portapapeles

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
    final response = await http.get(Uri.parse(
        'http://localhost/mandangon/obtener_resenias.php?rest_id=${widget.restaurante['id_rest']}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['resenias'] != null) {
        setState(() {
          puntuacionMedia = data['media']?.toDouble() ?? 0.0;
        });
      }
    }
  }

  // Función para abrir la URL de la página web del restaurante
  Future<void> visitarWeb() async {
    final url = widget.restaurante['rest_web'] ?? '';
    if (url.isNotEmpty && await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede abrir la página web.")),
      );
    }
  }

  // Función para abrir la dirección en Google Maps
  Future<void> abrirDireccion() async {
    final direccion = widget.restaurante['rest_ubi'] ?? '';
    final mapsUrl = 'https://www.google.com/maps/search/?q=$direccion';
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se puede abrir Google Maps.")),
      );
    }
  }

  // Función para compartir el restaurante
  Future<void> compartirRestaurante(String opcion) async {
    final url = widget.restaurante['rest_web'] ?? '';
    final nombre = widget.restaurante['rest_nom'];
    final direccion = widget.restaurante['rest_ubi'] ?? '';

    // Codificar la dirección correctamente para la URL
    final direccionCodificada = Uri.encodeComponent(direccion);

    // Crear el mensaje con nombre, web y dirección a modo de enlace
    final mensaje = '$nombre - $url\n\nUbicación: https://www.google.com/maps?q=$direccionCodificada';

    // Añadir el pie de mensaje con el origen de la app
    final pieMensaje = '\n\nEnviado desde la app Mandangon';

    // Crear el mensaje completo
    final mensajeCompleto = '$mensaje$pieMensaje';

    if (opcion == 'whatsapp') {
      // Codificar el mensaje completo para WhatsApp
      final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent('¡Hola!\n\nTe comparto el restaurante:\n\n$mensajeCompleto')}';  // Codificar todo el mensaje
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se puede abrir WhatsApp.")),
        );
      }
    } else if (opcion == 'email') {
      // Crear el cuerpo del correo con el mensaje más el pie de mensaje
      final cuerpoCorreo = '¡Hola!\n\nTe comparto el restaurante:\n\n$mensaje$pieMensaje';
      final emailUrl = 'mailto:?subject=Restaurante $nombre&body=${Uri.encodeComponent(cuerpoCorreo)}';
      if (await canLaunch(emailUrl)) {
        await launch(emailUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se puede abrir el correo.")),
        );
      }
    } else if (opcion == 'copy') {
      await Clipboard.setData(ClipboardData(text: '¡Hola!\n\nTe comparto el restaurante:\n\n$mensajeCompleto'));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mensaje copiado al portapapeles")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Separar los tipos de comida con un espacio después de cada coma
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
                      // Nombre del restaurante dentro de la tarjeta
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
                            tiposComida, // Mostramos los tipos de comida con el formato adecuado
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Ubicación del restaurante con título en negrita
                      Text(
                        '📍 Ubicación:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: abrirDireccion,
                        child: Text(
                          widget.restaurante['rest_ubi'] ?? '',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 9, 77, 133),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Teléfono del restaurante con título en negrita
                      Text(
                        '📞 Teléfono:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(widget.restaurante['rest_tel']),
                      const SizedBox(height: 12),
                      // Descripción con eliminación de espacios extra al inicio y texto justificado
                      Text(
                        '📝 Descripción:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Hacer scroll en la descripción si es muy larga
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.restaurante['rest_desc']?.trimLeft() ?? '',
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Puntuación media con título en negrita
                      Text(
                        '⭐️ Puntuación media:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('$puntuacionMedia'),
                      const SizedBox(height: 12),
                      // Página web del restaurante con icono
                      if (widget.restaurante['rest_web'] != null)
                        TextButton(
                          onPressed: visitarWeb,
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
                      // Botón para ver y añadir reseñas
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
                          child: const Text("Ver/Añadir Reseñas", style: TextStyle(color: Colors.black, fontSize: 16,
                      fontWeight: FontWeight.bold,)),
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
                                      compartirRestaurante('whatsapp');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.email, color: Colors.blue),
                                    title: const Text("Enviar por Correo"),
                                    onTap: () {
                                      compartirRestaurante('email');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.copy, color: Colors.black),
                                    title: const Text("Copiar al Portapapeles"),
                                    onTap: () {
                                      compartirRestaurante('copy');
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
