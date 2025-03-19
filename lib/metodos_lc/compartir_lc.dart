import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart'; // Para copiar al portapapeles

void mostrarOpcionesCompartir(
    BuildContext context, Map<String, dynamic> lista) {
  String titulo = "*${lista["nombre"]}*";
  List<dynamic> productos = lista["productos"] ?? [];
  
  // Crear el contenido de la lista
  String contenido = "$titulo\n\n${productos.map((p) => "• $p").join("\n")}";

  // Crear el mensaje completo con la introducción
  final mensajeCompleto =
      '¡Hola! Te comparto mi lista de compras:\n\n$contenido\n\nEnviado desde la app Mandangon';

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Compartir por WhatsApp'),
              onTap: () async {
                final Uri whatsappUrl = Uri.parse(
                    "https://wa.me/?text=${Uri.encodeComponent(mensajeCompleto)}");
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No se pudo abrir WhatsApp')),
                  );
                }
                Navigator.pop(context); // Cierra el diálogo
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Compartir por Correo'),
              onTap: () async {
                final cuerpoCorreo = mensajeCompleto;
                final Uri emailUrl = Uri.parse(
                    "mailto:?subject=Lista de Compra&body=${Uri.encodeComponent(cuerpoCorreo)}");
                if (await canLaunchUrl(emailUrl)) {
                  await launchUrl(emailUrl);
                }
                Navigator.pop(context); // Cierra el diálogo
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copiar al Portapapeles'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: mensajeCompleto));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Texto copiado al portapapeles")),
                );
                Navigator.pop(context); // Cierra el diálogo
              },
            ),
          ],
        ),
      );
    },
  );
}
